class_name FileUtils

static func load_json(file_path: String) -> Variant:
	if(FileAccess.file_exists(file_path)):
		var data_file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result: Variant = JSON.parse_string(data_file.get_as_text())
		return parsed_result
	return null;
	
static func find_resources_of_type(resource_type: String, directory: String = "res://") -> Array:
	var found_resources: Array = []
	var dir = DirAccess.open(directory)

	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			var file_path = directory + file_name
			
			if dir.current_is_dir():
				# Recursively scan subdirectories
				found_resources.append_array(find_resources_of_type(resource_type, file_path + "/"))
			else:
				# Check if the file is a resource
				if file_name.ends_with(".tres") or file_name.ends_with(".res"):
					var res = ResourceLoader.load(file_path)
					if res and res.get_class() == resource_type:  # Compare class names
						found_resources.append(file_path)
			file_name = dir.get_next()
			
	return found_resources
