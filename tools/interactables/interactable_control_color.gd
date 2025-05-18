@tool
extends Interactable

@export var render_settings: RenderLayerSettings:
	set(value):
		render_settings = value;
		if render_settings:
			layers = 1;
			set_instance_shader_parameter("tint_color", render_settings.render_colour)

func _ready() -> void:
	if Manager.instance:
		Manager.instance.render_layer_changed.connect(_on_render_layer_changed)
	super();
	_on_render_layer_changed(1);
	
func _on_render_layer_changed(layer_mask: int) -> void:
	var is_in_layer: bool = layer_mask & render_settings.render_layer != 0;
	set_instance_shader_parameter("color_mode", 0 if is_in_layer else 2)
	set_interactable(is_in_layer)
