class_name Interactable extends MeshInstance3D

signal primary();
signal clicked(button_index: int);

var click_area: Area3D;

@export_group("Properties")
@export var can_interact: bool = false;
@export var interactable_id: String;
var last_button_index: int = 0;

func _ready() -> void:
	click_area = $clickable_area;
	if Manager.instance:
		if click_area:
			click_area.collision_layer = Manager.instance.interactable_layer;
			click_area.set_meta("interactable", self);
		else:
			Debug.warn("No area found for interactable %s." % interactable_id)
	
func on_click(btn_index: int) -> void:
	if !can_interact:
		return;
		
	last_button_index = btn_index;
	execute(last_button_index);
	clicked.emit(btn_index);
	
func execute(btn_index: int = 0) -> void:
	if btn_index == 0:
		primary.emit();
