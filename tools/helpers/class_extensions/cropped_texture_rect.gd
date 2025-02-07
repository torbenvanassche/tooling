@tool
class_name CustomTextureRect extends Control

@export var texture: Texture2D;
@export var size_override_x: int = 50;
@export var sprite_size: Vector2;
@export var origin_rect: Rect2 = Rect2(0, 0, 1, 1):
	set(value):
		origin_rect = value
		queue_redraw()

func _draw() -> void:
	if origin_rect.size == Vector2.ZERO || !texture:
		return;
	
	size.x = size_override_x * origin_rect.size.x / origin_rect.size.y;
	size.y = size.x * (origin_rect.size.y / origin_rect.size.x)
	draw_texture_rect_region(texture, Rect2(0, 0, size.x, size.y), origin_rect)
