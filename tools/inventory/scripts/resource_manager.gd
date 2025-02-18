@tool
class_name ResourceManager extends Node

static var instance: ResourceManager;

func _init() -> void:
	instance = self;

@export_tool_button("Populate") var populate: Callable = Populate
func Populate() -> void:
		items.clear();
		var item_paths := FileUtils.get_resource_paths("resources/item_data");
		for path in item_paths:
			var r: ItemResource = ResourceLoader.load("res://" + path);
			items.append(r)
		notify_property_list_changed()

@export var items: Array[ItemResource];

func get_item(item_name: String) -> ItemResource:
	var valid_items := items.filter(func(x: ItemResource) -> bool: return x.name == item_name);
	if valid_items.size() == 1:
		return valid_items[0];
	else:
		return null;
