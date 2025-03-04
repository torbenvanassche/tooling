class_name ContentSlot extends Node

var _content: Resource;
var count: int = 0;
var _maxcount: int = 0;
var is_unlocked: bool = false;

signal changed();

func _init(count: int = 0, _content: Resource = null, _maxcount: int = 1, _unlocked: bool = true) -> void:
	self.is_unlocked = _unlocked;
	self._maxcount = _maxcount;
	set_content(_content);
	self.count = count;
	
func set_content(_content: Resource) -> void:
	self._content = _content;
	changed.emit();
	
func get_content() -> Resource:
	return _content;
	
func set_stack_size(max: int = 1) -> void:
	self._maxcount = max;
	
func can_add(content: Resource, amount: int) -> bool:
	return content != self._content && !is_full();

func add(amount: int = 1, content: Resource = null) -> int:
	if self._content == null && content != null:
		self._content = content;
	
	if content != null && self._content != content:
		return amount;
		
	var remaining_space: int = _maxcount - count;
	var amount_to_add: int = min(amount, remaining_space);
	self.count += amount_to_add;
	changed.emit();
	return amount - amount_to_add;
	
func remove(amount: int = 1) -> int:
	var amount_to_remove: int = min(amount, count);
	count -= amount_to_remove;
	if count == 0:
		reset()
	changed.emit();
	return amount - amount_to_remove
	
func match_or_empty(element: Resource) -> bool:
	return has_content(element) || has_content(null);
	
func has_content(element: Resource) -> bool: 
	return _content == element
	
func is_full() -> bool:
	return count >= _maxcount;

func reset() -> void:
	_content = null;
	count = 0;
