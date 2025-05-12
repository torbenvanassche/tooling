class_name Manager extends Node

@export var settings: Settings;
static var instance: Manager;

var interactable_layer: int = 1 << 3;

func _init() -> void:
	instance = self;
