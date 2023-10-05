extends CharacterBody3D

var speed = 3.0

@onready var target = $"../Player"

var health = 10

const LERP_VAL = .15

func _ready():
	events.enemy_damaged.connect(damage)

func _physics_process(delta):
	var target_direction = (target.transform.origin - transform.origin).normalized()
	var desired_rotation = atan2(-target_direction.z, target_direction.x)
	
	rotate_y(90)
	
	if target == null: get_tree().get_nodes_in_group("Player")[0]
	
	if not is_on_floor():
		velocity.y -= 15 * delta
	
	if target != null: 
		velocity = transform.origin.direction_to(target.transform.origin) * speed
	
		if velocity:
			rotation.y = lerp_angle(rotation.y, desired_rotation, LERP_VAL)
	
		move_and_slide()

func _process(delta):
	if health == 0:
		self.queue_free()

func damage():
	health -= 2

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		events.emit_signal("damage_player")
		events.emit_signal("update_healthbar")
		set_physics_process(false)
		$"attack cooldown".start()

func _on_attack_cooldown_timeout():
	set_physics_process(true)
