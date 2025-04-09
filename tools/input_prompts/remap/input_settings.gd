extends Node

@export var keybind_container: Node;
@onready var keybind_template: PackedScene = preload("res://tools/input_prompts/ui/action_setter.tscn")
@onready var reset_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/reset;
@onready var confirm_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/confirm;

func _ready() -> void:
	InputMap.load_from_project_settings();
	reset_button.pressed.connect(_load_default)
	confirm_button.pressed.connect(_on_save)
	
	_load_bindings();
	_reset_bindings();
	
func _load_default() -> void:
	InputMap.load_from_project_settings();
	_reset_bindings();
	
	for action: String in InputManager.mappable_actions:
		var events: Array[InputEvent] = InputMap.action_get_events(action);
		if events.size() > 0:
			Config.change_keybinding(action, events[0]);
	
func _on_save() -> void:
	Config.save();

func _reset_bindings() -> void:
	for item in keybind_container.get_children():
		item.queue_free()

	for action: String in InputManager.mappable_actions:
		var btn: InputRemappingButton = keybind_template.instantiate();
		btn.set_label(InputManager.mappable_actions[action]);
		var events: Array[InputEvent] = InputMap.action_get_events(action);
		for event in events:
			var key: String = event.as_text().to_lower();
			btn.set_key(key, event);
		
		keybind_container.add_child(btn);
		btn.pressed.connect(_on_rebind_key.bind(btn, action))
		
func _load_bindings() -> void:
	var keybindings: Dictionary = Config.load_keybindings();
	for action: String in keybindings.keys():
		InputManager.set_action(action, keybindings[action])

func _on_rebind_key(button: InputRemappingButton, action: String) -> void:
	if not InputManager.is_remapping:
		InputManager.is_remapping = true;
		InputManager.action_to_remap = action;
		InputManager.remapping_button = button;
		button.set_rebinding()
		
func _input(event: InputEvent) -> void:
	InputManager.is_keyboard = event is InputEventKey || event is InputEventMouseButton || event is InputEventMouseMotion;
	
	if InputManager.is_remapping:
		if event is InputEventKey || (event is InputEventMouseButton && event.pressed) || event is InputEventJoypadButton || event is InputEventJoypadMotion:
			InputManager.replace_action(InputManager.action_to_remap, event)
			get_viewport().set_input_as_handled()
