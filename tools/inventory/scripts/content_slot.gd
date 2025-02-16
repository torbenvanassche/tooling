class_name ContentSlot extends Node

var _content: Node;
var _count: int = 0;
var _max_count: int = 0;
var is_unlocked: bool = false;

signal changed();

func _init(_count: int = 0, _content: Node = null, _max_count: int = 1, _unlocked: bool = true) -> void:
	self.is_unlocked = _unlocked;
	self._max_count = _max_count;
	set_content(_content);
	self._count = _count;
	
func set_content(_content: Node) -> void:
	self._content = _content;
	
func set_stack_size(max: int = 1) -> void:
	self._max_count = max;

func add(amount: int = 1, content: Node = null) -> int:
	if content != null && self._content != content:
		return amount;
		
	if self._content == null && content != null:
		self._content = content;
		
	var remaining_space: int = _max_count - _count;
	var amount_to_add: int = min(amount, remaining_space);
	self._count += amount_to_add;
	changed.emit();
	return self._count - amount_to_add;
	
func remove(amount: int = 1) -> int:
	var amount_to_remove: int = min(amount, _count);
	_count -= amount_to_remove;
	if _count == 0:
		reset()
	changed.emit();
	return amount - amount_to_remove
	
func match_or_empty(element: Node) -> bool:
	return has_content(element) || has_content();
	
func has_content(element: Node = null) -> bool: 
	return _content == element
	
func reset() -> void:
	_content = null;
