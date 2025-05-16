extends PlayerCharacter

@export_group("Keybind variables")
@export var ability_1_action: String = "ability_1";
@export var ability_2_action: String = "ability_2";
@export var ability_3_action: String = "ability_3";

@export var color_mappings: Dictionary[String, RenderLayerSettings];

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(ability_1_action):
		_toggle_layer(color_mappings["red"].render_layer)
	elif Input.is_action_just_pressed(ability_2_action):
		_toggle_layer(color_mappings["green"].render_layer)
	elif Input.is_action_just_pressed(ability_3_action):
		_toggle_layer(color_mappings["blue"].render_layer)
	super(delta)
	
func _toggle_layer(layer: int) -> void:
	var current_mask: int = camHolder.camera.cull_mask
	var is_active := (current_mask & layer) != 0
	var new_mask: int = 1 << 0 if is_active else (1 << 0) | layer;
	camHolder.set_culling_mask(new_mask)
