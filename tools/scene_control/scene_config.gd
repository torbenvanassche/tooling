class_name SceneConfig
extends Resource

var disable_processing: bool = false;
var add_to_stack: bool = false;

func _init(disable_process: bool = false, _add_to_stack: bool = true) -> void:
	disable_processing = disable_process;
	add_to_stack = _add_to_stack;
