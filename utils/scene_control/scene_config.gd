class_name SceneConfig
extends Resource

var hide_list: Array[String] = [];
var disable_processing: bool = false;
var free_current: bool = false;
var add_to_stack: bool = false;

func _init(hidden_list: Array[String] = [], disable_process: bool = false, _add_to_stack: bool = true, _free_current: bool = false) -> void:
	disable_processing = disable_process;
	add_to_stack = _add_to_stack;
	hide_list = hidden_list;
	free_current = _free_current;
