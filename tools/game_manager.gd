class_name Manager extends Node

@export var settings: Settings;
static var instance: Manager

func _init() -> void:
	instance = self;
