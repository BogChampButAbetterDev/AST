extends CharacterBody3D

var speed = 10.0

func _ready():
	set_physics_process(false)
	events.shoot.connect(shoot)

func _physics_process(delta):
	translate(Vector3(-speed * delta, 0, 0))

func shoot():
	set_physics_process(true)

func _on_area_3d_body_entered(body):
	if body.is_in_group('Player'):
		print('balls')
		events.emit_signal("damage_player")
