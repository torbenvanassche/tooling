extends Node

@onready var mappable_actions: Dictionary = {
	"forward": tr("KEYBIND_MOVE_UP"),
	"back": tr("KEYBIND_MOVE_DOWN"),
	"left": tr("KEYBIND_MOVE_LEFT"),
	"right": tr("KEYBIND_MOVE_RIGHT"),
	"jump": tr("KEYBIND_JUMP"),
	"crouch": tr("KEYBIND_CROUCH"),
	"sprint": tr("KEYBIND_SPRINT"),
	"primary_action": tr("KEYBIND_PRIMARY_ACTION"),
	"secondary_action": tr("KEYBIND_SECONDARY_ACTION"),
	"interact": tr("KEYBIND_INTERACT"),
	"cancel": tr("KEYBIND_CANCEL")
}

var action_to_remap: StringName;
var is_remapping: bool = false;
var remapping_button: InputRemappingButton = null;
var dictionary_path: String = "res://tools/input_prompts/input_prompts.json"

signal input_mode_changed(is_kb: bool);
var is_keyboard: bool = true:
	set(value):
		if is_keyboard != value:
			is_keyboard = value
			input_mode_changed.emit(value)

var keys: Dictionary:
	get:
		if !keys:
			if !FileAccess.file_exists(dictionary_path):
				Debug.message("There is no file at %s" % dictionary_path);
				return {};
			keys = FileUtils.load_json(dictionary_path)
		return keys;

func get_key(key: String) -> Array:
	var result: Array = keys.keyboard.get(key);
	return result if result != null else []

func set_action(action: StringName, event: InputEvent) -> void:
	var action_split: PackedStringArray = action.split(".");
	var mapped_actions := InputMap.action_get_events(action_split[1]);
	
	var to_remove: InputEvent;
	for mapped_action in mapped_actions:
		if action_split[0] == "con":
			to_remove = mapped_actions.filter(func(x: InputEvent) -> bool: return x is InputEventJoypadButton|| x is InputEventJoypadMotion)[0];
		elif action_split[0] == "kb":
			to_remove = mapped_actions.filter(func(x: InputEvent) -> bool: return x is InputEventKey || x is InputEventMouseButton)[0];
			
	if action_split[1] != "":
		InputMap.action_erase_event(action_split[1], to_remove);
		InputMap.action_add_event(action_split[1], event)

func replace_action(action: StringName, event: InputEvent) -> void:
	set_action("kb." if is_keyboard else "con." + action, event)
	remapping_button.set_key(event.as_text().trim_suffix(" (Physical)").to_lower(), event)
	Config.change_keybinding(action_to_remap, event)
	
	is_remapping = false;
	action_to_remap = "";
	remapping_button = null;
