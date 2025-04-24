class_name Manager extends Node

@export var settings: Settings;
static var instance: Manager;

@export_flags_3d_physics var interactable_layer: int = 1 << 3; 

func _init() -> void:
	instance = self;
