class_name GameConfig extends Node

var config := ConfigFile.new();
const FILE_PATH = "user://settings.ini"

const KEYBIND_KB = "keybinds_keyboard"
const KEYBIND_CON = "keybinds_controller"

func _ready() -> void:
	if !FileAccess.file_exists(FILE_PATH):
		for keybind: String in InputManager.mappable_actions:
			var events: Array[InputEvent] = InputMap.action_get_events(keybind);
			for event in events:
				var key: String;
				if event is InputEventKey:
					key = OS.get_keycode_string(event.physical_keycode).to_lower()
					config.set_value(KEYBIND_KB, keybind, key)
				elif event is InputEventMouseButton:
					key = "mouse_" + str(event.button_index);
					config.set_value(KEYBIND_KB, keybind, key)
				elif event is InputEventJoypadButton:
					key = "button_" + str(event.button_index)
					config.set_value(KEYBIND_CON, keybind, key)
		config.save(FILE_PATH)
	else:
		config.load(FILE_PATH)
		
func change_keybinding(action: StringName, event: InputEvent) -> void:
	var event_str: String;
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.physical_keycode);
	elif event is InputEventMouseButton:
		event_str = "mouse_" + str(event.button_index);
	config.set_value(KEYBIND_KB, action, event_str);
	
func save() -> void:
	config.save(FILE_PATH);

func load_keybindings() -> Dictionary:
	var keybindings: Dictionary = {};
	if config.has_section(KEYBIND_KB):
		var keys: PackedStringArray = config.get_section_keys(KEYBIND_KB);
		for key in keys:
			var input_event: InputEvent;
			var event_str: String = config.get_value(KEYBIND_KB, key);
		
			if event_str.contains("mouse_"):
				input_event = InputEventMouseButton.new();
				input_event.button_index = int(event_str.split("_")[1])
			else:
				input_event = InputEventKey.new();
				input_event.keycode = OS.find_keycode_from_string(event_str);
			
			keybindings[key] = input_event;
	return keybindings;
