extends Node

@onready var mappable_actions: Dictionary = {
	"forward": tr("KEYBIND_MOVE_UP"),
	"back": tr("KEYBIND_MOVE_DOWN"),
	"left": tr("KEYBIND_MOVE_LEFT"),
	"right": tr("KEYBIND_MOVE_RIGHT"),
	"cancel": tr("KEYBIND_CANCEL"),
	"interact": tr("KEYBIND_INTERACT"),
	"ability_1": tr("KEYBIND_ABILITY1"),
	"ability_2": tr("KEYBIND_ABILITY2"),
	"ability_3": tr("KEYBIND_ABILITY3"),
	"ability_4": tr("KEYBIND_ABILITY4"),
	"primary_action": tr("KEYBIND_PRIMARY_ACTION"),
	"secondary_action": tr("KEYBIND_SECONDARY_ACTION"),
}

var action_to_remap: StringName;
var is_remapping: bool = false;
var remapping_button: InputRemappingButton = null;
var dictionary_path: String = "res://input_prompts/input_prompts.json"

var keys: Dictionary:
	get:
		if !keys:
			keys = FileUtils.load_json(dictionary_path)
		return keys;

func get_key(key: String) -> Array:
	var result: Array = keys.keyboard.get(key);
	return result if result != null else []

func set_action(action: StringName, event: InputEvent) -> void:
	InputMap.action_erase_events(action);
	InputMap.action_add_event(action, event)

func replace_action(action: StringName, event: InputEvent) -> void:
	set_action(action, event)
	remapping_button.set_key(event.as_text().trim_suffix(" (Physical)").to_lower(), event)
	Config.change_keybinding(action_to_remap, event)
	
	is_remapping = false;
	action_to_remap = "";
	remapping_button = null;
