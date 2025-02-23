class_name ContextMenu
extends PopupMenu

var menu_items: Array[ContextMenuItem]
var item_size: Vector2 = Vector2(100, 24);

func _init(data: Array[ContextMenuItem] = []) -> void:
	menu_items = data
	
	for index in range(menu_items.size()):
		var context_item := menu_items[index]
		add_item(context_item.id, index)
		set_item_disabled(index, !context_item.enabled)
		context_item.idx = index

func _ready() -> void:
	close_requested.connect(_on_close)
	index_pressed.connect(_on_idx)
	if Manager.instance.settings.close_context_on_mouse_exit:
		mouse_exited.connect(_on_close)

func add(cmi: ContextMenuItem) -> void:
	var idx: int = menu_items.size()
	if menu_items.filter(func(item: ContextMenuItem) -> bool: return item.idx == idx).size() == 0:
		add_item(cmi.id, idx)
		set_item_disabled(idx, !cmi.enabled)
		cmi.idx = idx
		menu_items.append(cmi)

func _on_idx(index: int) -> void:
	var found_item: Array[ContextMenuItem] = menu_items.filter(func(x: ContextMenuItem) -> bool: return x.idx == index)
	for item in found_item:
		item.function.call()
	close_requested.emit();

func _on_close() -> void:
	queue_free()

func open(vec2: Vector2) -> void:
	popup(Rect2(vec2, Vector2(item_size.x, item_size.y * menu_items.size())))
