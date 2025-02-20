class_name ContextMenuItem
extends Node

var id: String;
var function: Callable;
var enabled: bool;
var idx: int = -1;

func _init(i: String, f: Callable, _enabled: bool = false) -> void:
	id = i;
	function = f;
	enabled = _enabled;
