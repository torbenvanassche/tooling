class_name Manager extends Node

@export var settings: Settings;
static var instance: Manager;

var interactable_layer: int = 1 << 3;
signal render_layer_changed(render_layer: int)

func _init() -> void:
	instance = self;
