extends CharacterBody3D

var speed = 3.0

@onready var target = $"../Player"

var health = 20

const LERP_VAL = .15

func _ready():
	set_physics_process(false)
	events.valid_damage.connect(damage)

func _physics_process(delta):
	rotate_y(90)
	
	if target == null:
		get_tree().get_nodes_in_group("Player")[0]
	
	if target != null: 
		velocity = transform.origin.direction_to(target.transform.origin) * speed
	
	move_and_slide()

func _process(delta):
	if health == 0:
		events.emit_signal('spinner_killed')
		self.queue_free()

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		events.emit_signal("damage_player")
		events.emit_signal("update_healthbar")
		set_physics_process(false)
		$"attack cooldown".start()

func _on_attack_cooldown_timeout():
	set_physics_process(true)

func damage():
	print('damage')
	health -= 5
	$"attack cooldown".start()

func _on_attack_trigger_body_entered(body):
	if body.is_in_group("Player"):
		set_physics_process(true)
