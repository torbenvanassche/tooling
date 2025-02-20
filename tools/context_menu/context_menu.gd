class_name ContextMenu
extends PopupMenu

var menu_items: Array[ContextMenuItem];

func _ready() -> void:
	close_requested.connect(_on_close)

func _init(data: Array[ContextMenuItem]) -> void:
	for index in range(data.size()):
		var context_item := data[index];
		add_item(context_item.id, index)
		set_item_disabled(index, context_item.disabled)
		context_item.idx = index;

	menu_items = data
	size.y = 0
	
	index_pressed.connect(_on_idx)
	if Manager.instance.settings.close_context_on_mouse_exit:
		mouse_exited.connect(_on_close)
		
func add(cmi: ContextMenuItem) -> void:
	var idx: int = menu_items.size();
	if menu_items.filter(func(item: ContextMenuItem) -> bool: return item.idx == idx).size() == 0:	
		add_item(cmi.id, idx)
		set_item_disabled(idx, cmi.disabled)
		cmi.idx = idx;
		menu_items.append(cmi);
	
func _on_idx(index: int) -> void:
	var found_item: Array[ContextMenuItem] = menu_items.filter(func(x: ContextMenuItem) -> bool: return x.idx == index);
	for item in found_item:
		item.function.call()
	close_requested.emit();

func _on_close() -> void:
	queue_free()

func open(rect: Rect2) -> void:
	popup(rect);
