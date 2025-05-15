extends PlayerCharacter

@export_group("Keybind variables")
@export var ability_1_action: String = "ability_1";
@export var ability_2_action: String = "ability_2";
@export var ability_3_action: String = "ability_3";

func _physics_process(delta: float) -> void:
	Input.is_action_just_pressed(ability_1_action):
		pass;
