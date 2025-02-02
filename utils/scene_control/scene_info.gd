class_name SceneInfo
extends Resource

@export var id:String
@export_file var packed_scene: String;
@export var is_ui: bool = false;
var node: Node;

signal cached(scene_info: SceneInfo);
