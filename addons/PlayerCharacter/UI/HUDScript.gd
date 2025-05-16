extends CanvasLayer

class_name HUD

#label references variables
@onready var currentStateLT: Label = $PlayCharInfos/VBoxContainer2/CurrentStateLabelText
@onready var desiredMoveSpeedLT: Label = $PlayCharInfos/VBoxContainer2/DesiredMoveSpeedLabelText
@onready var velocityLT: Label = $PlayCharInfos/VBoxContainer2/VelocityLabelText
@onready var nbJumpsInAirAllowedLT: Label = $PlayCharInfos/VBoxContainer2/NbJumpsInAirAllowedLabelText
@onready var framesPerSecondLT: Label = $PlayCharInfos2/VBoxContainer2/FramesPerSecondLabelText

@export var enabled: bool = false;

func _process(_delta):
	displayCurrentFPS()
	
func _ready() -> void:
	if !enabled:
		disable();
		
func displayCurrentState(currentState : String):
	currentStateLT.set_text(str(currentState))
	
func displayDesiredMoveSpeed(desiredMoveSpeed : float):
	desiredMoveSpeedLT.set_text(str(desiredMoveSpeed))
	
func displayVelocity(velocity : float):
	velocityLT.set_text(str(velocity))
	
func displayNbJumpsInAirAllowed(nbJumpsInAirAllowed : int):
	nbJumpsInAirAllowedLT.set_text(str(nbJumpsInAirAllowed))
	
func displayCurrentFPS():
	framesPerSecondLT.set_text(str(Engine.get_frames_per_second()))

func disable():
	$PlayCharInfos.visible = false;
	$PlayCharInfos2.visible = false;
	process_mode = Node.PROCESS_MODE_DISABLED;
