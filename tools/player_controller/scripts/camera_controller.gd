extends CameraObject

@onready var ray: RayCast3D = $Camera/RayCast3D;

func _ready() -> void:
	ray.collision_mask = Manager.instance.interactable_layer;
	super();
	
func _unhandled_input(event: InputEvent) -> void:
	if !mouseFree:
		_raycast_mouse_direction();
		super(event);

func _raycast_mouse_direction() -> void:
	if Input.is_action_just_pressed("primary_action"):
		var area: Area3D = ray.get_collider();
		if area:
			area.get_meta("interactable").on_click(0);
			
func set_culling_mask(mask: int) -> void:
	Manager.instance.render_layer_changed.emit(mask);
	camera.cull_mask = mask;

func cameraBob(delta: float) -> void:
	if playChar.stateMachine.currStateName != "Idle":
		super(delta);
