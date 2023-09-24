extends CharacterBody3D

var speed = 250.0

@onready var target = $"../Player"
@onready var body = $body
@onready var anim = $AnimationPlayer
@onready var bullet_starting_pos = $bullet_staring_position
@onready var bullet = $bullet

var health = 10

const LERP_VAL = .15

var already_rotated_for_combat = false
var bullet_rotated = false

var attack 

var can_shoot = false

func _ready():
	events.enemy_damaged.connect(damage)
	set_physics_process(false)

func _physics_process(delta):
	if not already_rotated_for_combat:
		rotate_y(180.7)
		already_rotated_for_combat = true
	
	var target_direction = (target.transform.origin - transform.origin).normalized()
	var desired_rotation = atan2(-target_direction.z, target_direction.x)
	
	if target == null:
		target = get_node("../Player")
	
	if not is_on_floor():
		velocity.y -= 15 * delta
	
	if target != null:
		velocity = transform.origin.direction_to(target.transform.origin) * speed * delta
		
		if velocity:
			body.rotation.y = lerp_angle(body.rotation.y, desired_rotation, LERP_VAL)
			bullet_starting_pos.rotation.y = lerp_angle(bullet_starting_pos.rotation.y, desired_rotation, LERP_VAL)
			attack = decide_if_attack()
		
		if attack:
			if can_shoot:
				events.emit_signal("shoot")
			#rotate_bullet()
	
		move_and_slide()

func decide_if_attack():
	randomize()
	
	var choice = randi_range(0, 1)
	
	if choice == 0:
		return false
	else:
		return true

func rotate_bullet():
	if not bullet_rotated and already_rotated_for_combat:
			bullet.rotate_y(90)
			bullet_rotated = true

func _process(delta):
	if health <= 0:
		self.queue_free()

func damage():
	anim.play("hit")
	health -= 2
	set_physics_process(false)
	$StopAfterCombat.start()

func reset_bullet_pos():
	bullet.transform.origin = bullet_starting_pos.transform.origin

func _on_attack_sensor_body_entered(body):
	if body.is_in_group("Player"):
		set_physics_process(true)

func _on_stop_after_combat_timeout():
	set_physics_process(true)

func _on_timer_timeout():
	can_shoot = true
