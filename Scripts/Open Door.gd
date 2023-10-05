extends AnimationPlayer

func _ready():
	events.can_open_door.connect(open_door)

func open_door():
	play("Open")
