@tool
extends MeshInstance3D

@export var radius: float = 0.5: 
	set(value):
		radius = value;
		mesh.radius = value;
		mesh.height = value * 2;
		apply_color_filter();
		
@export var segments: float = 16: 
	set(value):
		segments = value;
		mesh.radial_segments = value;
		mesh.rings = value;
		
var mesh_instances: Array[MeshInstance3D] = [];

func apply_color_filter() -> void:
	if Engine.is_editor_hint():
		mesh_instances = FileUtils.get_all_mesh_instances(self);
		
	for mesh in mesh_instances:
		mesh.set_instance_shader_parameter("sphere_center", global_position);
		mesh.set_instance_shader_parameter("sphere_radius", radius);
		
func _ready() -> void:
	mesh_instances = FileUtils.get_all_mesh_instances(self);
	mesh = mesh.duplicate(false);
	apply_color_filter()
