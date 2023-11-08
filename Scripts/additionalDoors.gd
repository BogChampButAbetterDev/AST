extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	events.spinner_killed.connect(open_key_door)

func open_key_door():
	$DoorAnimation.play("KeyDoorOpen")
