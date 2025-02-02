class_name SceneCache extends Node

var cached_scenes: Array[SceneInfo] = [];
var loading_queue: Array[SceneInfo] = [];
var timers: Array[Timer] = [];
	
func _init() -> void:
	var timer: Timer = Timer.new();
	timer.timeout.connect(_check_progress)
	timer.wait_time = 0.1;
	
	timers.append(timer);
	add_child(timer)
	timer.start();

func queue(scene_info: SceneInfo) -> void:
	loading_queue.append(scene_info);
	var error: Error = ResourceLoader.load_threaded_request(scene_info.packed_scene, type_string(typeof(PackedScene)))
	if error:
		loading_queue.erase(scene_info)
		Debug.err(str(error))

func _check_progress() -> void:
	for loading in loading_queue:
		if ResourceLoader.load_threaded_get_status(loading.packed_scene) == ResourceLoader.THREAD_LOAD_LOADED:
			loading.node = ResourceLoader.load_threaded_get(loading.packed_scene).instantiate();
			cached_scenes.append(loading)
			loading_queue.erase(loading)
			loading.cached.emit(loading);

func get_from_cache(scene_info: SceneInfo) -> Node:
	if cached_scenes.has(scene_info):
		return cached_scenes[cached_scenes.find(scene_info)].node;
	else:
		queue(scene_info)
		return null;
		
func is_cached(scene_info: SceneInfo) -> Variant:
	if loading_queue.has(scene_info) || cached_scenes.has(scene_info):
		return ResourceLoader.load_threaded_get_status(scene_info.packed_scene)
	else:
		return -1;
		
func remove(scene_info: SceneInfo) -> void:
	if cached_scenes.has(scene_info):
		cached_scenes[scene_info].node.queue_free();
		cached_scenes.erase(scene_info);
