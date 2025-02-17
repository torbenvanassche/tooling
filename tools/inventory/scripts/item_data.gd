class_name ItemData extends Resource

var name: String;
@export var description: String;

func _get_property_list() -> Array[Dictionary]:
	if !resource_path.is_empty():
		name = resource_path.get_file();
	return [];
