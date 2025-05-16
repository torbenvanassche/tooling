@tool
extends MeshInstance3D

@export var radius: float = 0.5: 
	set(value):
		radius = value;
		(self.mesh as SphereMesh).radius = value;
		(self.mesh as SphereMesh).height = value * 2;
		
@export var segments: float = 16: 
	set(value):
		segments = value;
		(self.mesh as SphereMesh).radial_segments = value;
		(self.mesh as SphereMesh).rings = value;
