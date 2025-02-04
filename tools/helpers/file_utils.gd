class_name FileUtils

static func load_json(file_path: String) -> Variant:
	if(FileAccess.file_exists(file_path)):
		var data_file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result: Variant = JSON.parse_string(data_file.get_as_text())
		return parsed_result
	return null;
