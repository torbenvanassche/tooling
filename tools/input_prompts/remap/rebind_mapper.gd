class_name InputRemappingButton extends Button

@export var action_name: Label;
@export var action_image_keyboard: TextureRect;
@export var action_image_controller: TextureRect;
@export var rebinding_text: Label;
			
func set_key(string: String, event: InputEvent) -> void:
	var entry: Array
	if event is InputEventKey:
		string = OS.get_keycode_string(event.keycode).to_lower()
		if InputManager.keys.keyboard.mappings.has(string):
			entry = InputManager.keys.keyboard.mappings.get(string)
	elif event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				string = "left_mouse_button"
			MOUSE_BUTTON_RIGHT:
				string = "right_mouse_button"
			MOUSE_BUTTON_MIDDLE:
				string = "middle_mouse_button"
			_:
				string = "mouse_button " + str(event.button_index)
		string = string.trim_suffix(" (double click)")
		if InputManager.keys.mouse.mappings.has(string):
			entry = InputManager.keys.mouse.mappings.get(string)
	elif event is InputEventJoypadButton:
		string = "joy_button_" + str(event.button_index)
		if InputManager.keys.controller.mappings.has(string):
			entry = InputManager.keys.controller.mappings.get(string)
	elif event is InputEventJoypadMotion:
		string = "joy_axis_" + str(event.axis)
		if InputManager.keys.controller.mappings.has(string):
			entry = InputManager.keys.controller.mappings.get(string)
	if entry:
		rebinding_text.visible = false
		if event is InputEventKey or event is InputEventMouseButton:
			action_image_keyboard.texture = _create_atlas(InputManager.keys.keyboard.file_id if event is not InputEventMouseButton else InputManager.keys.mouse.file_id);
			action_image_keyboard.visible = true
			(action_image_keyboard.texture as AtlasTexture).region = Rect2(entry[0] * InputManager.keys.rect_size[0], entry[1] * InputManager.keys.rect_size[1], InputManager.keys.rect_size[0] * entry[2], InputManager.keys.rect_size[1] * entry[3])
		elif event is InputEventJoypadButton || event is InputEventJoypadMotion:
			action_image_controller.texture = _create_atlas(InputManager.keys.controller.file_id);
			action_image_controller.visible = true
			(action_image_controller.texture as AtlasTexture).region = Rect2(entry[0] * InputManager.keys.rect_size[0], entry[1] * InputManager.keys.rect_size[1], InputManager.keys.rect_size[0] * entry[2], InputManager.keys.rect_size[1] * entry[3])

func set_label(string: String) -> void:
	action_name.text = string;
	
func _create_atlas(id: String) -> AtlasTexture:
	var tex := AtlasTexture.new();
	tex.atlas = load(id);
	return tex;
	
func set_rebinding() -> void:
	rebinding_text.visible = true;
	action_image_keyboard.visible = false;
	action_image_controller.visible = false;
	
func set_active_input_mode(is_key: bool) -> void:
	action_image_controller.visible = !is_key;
	action_image_keyboard.visible = is_key;

func _ready() -> void:
	action_image_keyboard.texture = action_image_keyboard.texture.duplicate(true);
	InputManager.input_mode_changed.connect(set_active_input_mode)
	set_active_input_mode(InputManager.is_keyboard)
