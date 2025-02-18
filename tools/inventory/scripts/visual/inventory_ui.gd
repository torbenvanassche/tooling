extends Control

@export var inventory: Inventory;
@export var packed_slot: PackedScene;

@onready var root: GridContainer = $MarginContainer/GridContainer;

var selected_slot: ContentSlotUI;

func _ready() -> void:
	root.resized.connect(_control_size)
	
	for element in inventory.data:
		add(element)
	
func _control_size() -> void:
	for e: Control in root.get_children():
		var container_size_x: int = clamp((size.x / root.columns) - root.get_theme_constant("h_separation"), 50, 100);
		e.custom_minimum_size.x = container_size_x;
		e.custom_minimum_size.y = container_size_x;

func add(content: ContentSlot) -> ContentSlotUI:
	var container: ContentSlotUI = packed_slot.instantiate() as ContentSlotUI;
	container.button_up.connect(_set_selected.bind(container))
	container.set_content(content)
	root.add_child(container);
	return container;

func _set_selected(slot: ContentSlotUI) -> void:
	if !slot || (selected_slot != slot && selected_slot):
		selected_slot.button_pressed = false;
		selected_slot = null;
		
	var redraw: bool = selected_slot == slot;
	if redraw || slot:
		slot.button_pressed = false;
		selected_slot = null;
	else:
		selected_slot = slot;
