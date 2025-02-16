class_name ContentGroup extends Node

var data: Array[ContentSlot] = [];

@export var unlocked_slots: int = 1;
@export var max_slots: int = 1;
@export var stack_size: int = 1;

signal on_item_add_failed();

func _ready() -> void:
	for i in range(max_slots):
		data.append(ContentSlot.new(0, null, stack_size, i < unlocked_slots))
		
func get_available_slots(content: Node) -> Array[ContentSlot]:
	return data.filter(func(slot: ContentSlot) -> bool: return slot.is_unlocked && slot.match_or_empty(content))
	
func create_or_unlock_slot() -> ContentSlot:
	for slot in data:
		if !slot.is_unlocked:
			slot.unlock();
			return slot;
	var new_slot: ContentSlot = ContentSlot.new(0, null, stack_size, true);
	data.append(new_slot);
	return new_slot;
	
func add_item(content: Node, amount: int = 1, can_exceed_capacity: bool = false) -> int:
	var remaining_amount: int = amount;
	while remaining_amount > 0:
		var slots: Array[ContentSlot] = get_available_slots(content);
		if slots.size() == 0:
			if can_exceed_capacity:
				create_or_unlock_slot()
				continue;
			break;
			
		remaining_amount = slots[0].add(remaining_amount, content);
	if remaining_amount != 0:
		on_item_add_failed.emit()
	return remaining_amount;

func remove_item(content: Node, amount: int = 1) -> int:
	var remaining_amount: int = amount;
	while remaining_amount > 0:
		var slots: Array[ContentSlot] = get_available_slots(content);
		if slots.size() == 0:
			break;
		remaining_amount = slots[0].remove(remaining_amount);
	return remaining_amount;
