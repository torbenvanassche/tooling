class_name Settings
extends Resource
	
#camera sensitivity
@export var camera_zoom_sensitivity: float = 0.5;
@export var camera_follow_speed: float = 1;

#menu options
@export var close_context_on_mouse_exit: bool = true;

#volume
@export var master_volume: float = 1;
signal volume_changed(new_value: float, bus_name: String);

func _ready() -> void:
	_deferred_ready.call_deferred();

func _deferred_ready() -> void:
	volume_changed.connect(_change_volume);
	
func _change_volume(bus_name: String, value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value));
	master_volume = value;
