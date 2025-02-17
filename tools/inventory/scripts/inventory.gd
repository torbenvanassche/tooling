class_name Inventory extends ContentGroup

var test: ItemData = preload("res://resources/item_data/health_potion.tres");

func _ready() -> void:
	super();
	print(add_item(test, 2));
