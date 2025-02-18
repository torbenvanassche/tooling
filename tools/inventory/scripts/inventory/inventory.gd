class_name Inventory extends ContentGroup

func _ready() -> void:
	super();
	
	add.call_deferred(ResourceManager.instance.get_item("Wheat"))
	add.call_deferred(ResourceManager.instance.get_item("Mythril"))
