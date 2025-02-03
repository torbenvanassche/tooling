extends Node2D

func on_enable() -> void:
	SceneManager.instance.load_scene("2", SceneConfig.new(false, false, false));
