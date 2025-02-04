class_name InputMapper extends Node

static func get_key(key: String) -> String:
	if InputMap.has_action(key):
		return (InputMap.action_get_events(key)[0] as InputEventKey).as_text_physical_keycode().to_lower();
	return ""
