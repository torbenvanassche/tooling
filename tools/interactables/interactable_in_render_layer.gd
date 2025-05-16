@tool
extends Interactable

@export var render_settings: RenderLayerSettings:
	set(value):
		render_settings = value;
		if render_settings:
			layers = render_settings.render_layer;
			set_instance_shader_parameter("tint_color", render_settings.render_colour)
		else:
			layers = 0 << 1;
			set_instance_shader_parameter("tint_color", Color.WHITE)

func _ready() -> void:
	Manager.instance.render_layer_changed.connect(_on_render_layer_changed)
	
func _on_render_layer_changed(layer_mask: int) -> void:
	set_interactable(layer_mask & render_settings.render_layer != 0)
