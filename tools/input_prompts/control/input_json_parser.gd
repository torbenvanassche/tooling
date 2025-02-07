@tool
class_name InputDisplayerRect extends CustomTextureRect

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
		
		if !_keys.has(key):
			origin_rect = Rect2(0, 0, 0, 0);
			return;
		
		var entry: Array = _keys.keyboard.get(key)
		if entry:
			var x: int = entry[0] * _keys.rect_size[0];
			var y: int = entry[1] * _keys.rect_size[1];
			var width: int = _keys.rect_size[0] * entry[2];
			var height: int = _keys.rect_size[1] * entry[3]
			origin_rect = Rect2(x, y, width, height);
