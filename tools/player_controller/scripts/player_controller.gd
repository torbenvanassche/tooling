extends PlayerCharacter

@export_group("Keybind variables")
@export var ability_1_action: String = "ability_1";
@export var ability_2_action: String = "ability_2";
@export var ability_3_action: String = "ability_3";

@export var color_mappings: Dictionary[String, RenderLayerSettings];

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(ability_1_action):
		camHolder.set_culling_mask(1 << 0 | color_mappings["red"].render_layer)
	elif Input.is_action_just_pressed(ability_2_action):
		camHolder.set_culling_mask(1 << 0 | color_mappings["green"].render_layer)
	elif Input.is_action_just_pressed(ability_3_action):
		camHolder.set_culling_mask(1 << 0 | color_mappings["blue"].render_layer)
	super(delta)
