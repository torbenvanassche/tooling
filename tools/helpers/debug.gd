class_name Debug extends Node
static var show_log: bool = true;

static func message(s: String) -> void:
	if show_log:
		print(s);
		
static func warn(s: String) -> void:
	if show_log:
		push_warning(s);
		
static func err(s: String) -> void:
	if show_log:
		printerr(s);
