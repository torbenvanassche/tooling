@tool
class_name InputDisplayer extends CustomTextureRect

@export_file("*.json") var dictionary_path: String;
var _keys: Dictionary:
	get:
		if !_keys:
			_keys = FileUtils.load_json(dictionary_path)
		return _keys;

@export var key: String:
	set(value):
		_keys = FileUtils.load_json(dictionary_path)
		
		key = value;
		var entry = _keys.keyboard.get(key)
		if entry:
			origin_rect = Rect2(entry[0] * _keys.rect_size[0], entry[1] * _keys.rect_size[1], _keys.rect_size[0] * entry[2], _keys.rect_size[1] * entry[3])
			queue_redraw()
