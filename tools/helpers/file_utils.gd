class_name FileUtils

static func load_json(file_path: String) -> Variant:
	if(FileAccess.file_exists(file_path)):
		var data_file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result: Variant = JSON.parse_string(data_file.get_as_text())
		return parsed_result
	return null;

static func get_resource_paths(folder_path: String) -> Array[String]:
	var file_paths: Array[String] = []  
	var dir := DirAccess.open(folder_path)  
	
	if dir == null:
		return file_paths;
	
	dir.list_dir_begin()
	var file_name := dir.get_next()  
	while file_name != "":  
		var file_path: String = folder_path + "/" + file_name  
		if dir.current_is_dir():  
			file_paths += get_resource_paths(file_path)  
		else:  
			file_paths.append(file_path)  
		file_name = dir.get_next()  
	return file_paths
	
static func get_all_mesh_instances(node: Node) ->  Array[MeshInstance3D]:
	var meshes: Array[MeshInstance3D] = []

	if node is MeshInstance3D:
		meshes.append(node)

	for child in node.get_children():
		meshes += get_all_mesh_instances(child)

	return meshes
