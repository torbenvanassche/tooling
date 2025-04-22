extends CameraObject

@onready var ray: RayCast3D = $Camera/RayCast3D;

func _ready() -> void:
	super();
	
func _unhandled_input(event: InputEvent) -> void:
	if !mouseFree:
		super(event);

func _raycast_mouse_direction() -> void:
	if !mouseFree:
		if Input.is_action_just_pressed("primary_action"):
			var area: Area3D = ray.get_collider();
			if area:
				area.get_meta("interactable").on_click(0);
