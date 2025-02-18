class_name SceneManager
extends Node

@export var scenes: Array[SceneInfo];
var scene_stack: Array[SceneInfo] = [];
var scene_cache: SceneCache;
var load_in_progress: bool = false;

@export var initial_scene: SceneInfo;
@export var root: Node;
static var instance: SceneManager;

signal scene_entered(scene: Node)
signal scene_exited(scene: Node)

var _active_scene: Node:
	set(new_scene):
		if _active_scene != null:
			scene_exited.emit(_active_scene);
			if _active_scene.has_method("on_disable"):
				_active_scene.on_disable();
		_active_scene = new_scene;
		_active_scene.visible = true;
		scene_entered.emit(_active_scene);

func _init() -> void:
	SceneManager.instance = self;
	scene_cache = SceneCache.new()
		
func _ready() -> void:
	if initial_scene:
		load_scene(initial_scene.id, SceneConfig.new(true))
			
func get_or_create_scene(scene_name: String, scene_config: SceneConfig = SceneConfig.new()) -> Node:
	var filtered: Array = scenes.filter(func(scene: SceneInfo) -> bool: return scene != null && scene.id == scene_name);
	if filtered.size() == 0:
		Debug.err(scene_name + " was not found, unable to instantiate!")
	elif filtered.size() == 1:
		var scene_info: SceneInfo = filtered[0];
		if is_instance_valid(scene_info.node):
			_on_scene_load(scene_info, scene_config);
			return scene_info.node;
		else:
			load_in_progress = true;
			if scene_cache.get_from_cache(scene_info) != null:
				_on_scene_load(scene_info, scene_config);
			else:
				if !scene_info.cached.is_connected(_on_scene_load.bind(scene_config)):
					scene_info.cached.connect(_on_scene_load.bind(scene_config))
	else:
		Debug.err(scene_name + " was invalid. Found more than one resource referencing the scene.")
	return null;
		
func _on_scene_load(scene_info: SceneInfo, scene_config: SceneConfig) -> void:
	load_in_progress = false;
	if root != scene_info.node.get_parent():
		root.add_child(scene_info.node)
	_active_scene = scene_info.node;
	if _active_scene != null:
		_active_scene.visible = true;
		if scene_config.add_to_stack:
			scene_stack.append(node_to_info(_active_scene))
		if _active_scene.has_method("on_enable"):
			_active_scene.on_enable()
			_active_scene.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
			
func node_to_info(node: Node) -> SceneInfo:
	var filtered: Array[SceneInfo] = scenes.filter(func(x: SceneInfo) -> bool: return x.node == node);
	if filtered.size() == 1:
		return filtered[0];
	Debug.err("Could not find " + node.name + " in scenes.")
	return null
	
func get_scene_info(id: String) -> SceneInfo:
	var filtered: Array[SceneInfo] = scenes.filter(func(x: SceneInfo) -> bool: return x.id == id);
	if filtered.size() == 1:
		return filtered[0];
	Debug.err("Could not find " + id + " in scenes.")
	return null;

func set_scene_reference(id: String, target: Node) -> void:
	get_scene_info(id).node = target;
		
func load_scene(scene_name: String, config: SceneConfig) -> void:
	var previous_scene_info: SceneInfo = null;
	if _active_scene != null:
		previous_scene_info = node_to_info(_active_scene);
		if previous_scene_info.id == scene_name:
			return; 
		if config.disable_processing:
			_active_scene.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
		if config.free_current:
			scene_cache.remove(previous_scene_info)
	get_or_create_scene(scene_name, config)
	
func reset_to_scene(scene_name: String) -> void:
	for scene_info in scenes:
		if scene_info.id != scene_name && scene_info.node != null:
			scene_info.node.queue_free()
	load_scene(scene_name, SceneConfig.new())
		
func to_previous_scene(stop_processing_current: bool = false, _remove_current: bool = false) -> void:
	if scene_stack.size() != 0:
		scene_stack.pop_back();
		if scene_stack.size() != 0:
			load_scene(scene_stack[scene_stack.size() - 1].id, SceneConfig.new(stop_processing_current, false, _remove_current));
		
func ui_is_open(exceptions: Array[String]) -> bool:
	return get_children().all(func(x: Node) -> bool: return node_to_info(x).is_ui && x.visible && !exceptions.has(node_to_info(x).id));
			
func is_active(scene_name: String) -> bool:
	for scene_info in scenes:
		if scene_info.id != scene_name && scene_info.node != null && scene_info.node.visible == true:
			return true;
	return false;
