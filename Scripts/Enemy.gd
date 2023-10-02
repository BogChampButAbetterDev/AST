#TODO:
#get enemy's collision to move with the body <---- THAT SHIT IS DONE!!!!!!!!!!!!!
#get enemy to charge at the player <------------- THAT SHIT IS DONE!!!!!!!!!!!!!
#get enemy to reset if it has not hit the player

extends CharacterBody3D

var move_back_speed : float = -10.0
var charge_towrds_player_speed : float = -20.0
var reset_speed : float = 30.0

@onready var target = $"../Player"
@onready var body = $body
@onready var anim = $AnimationPlayer
@onready var colider = $CollisionShape3D
@onready var area_colider = $charge_damage_sensor

var health = 10

const LERP_VAL = .15

var already_rotated_for_combat = false
var already_rotated_for_combat_2 = false

var first_step_done = false
var step_2_done = false
var step_3_done = false

var can_charge = false

var hit_player = false

var player_dead = false

var initial_position : Vector3
var initial_rotation : float

func _ready():
	transform.origin = Vector3(0, 0.967, 17.901)
	initial_position = body.transform.origin
	initial_rotation = body.rotation.y
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
		enemy_ai(delta)
		
		if velocity:
			body.rotation.y = lerp_angle(body.rotation.y, desired_rotation, LERP_VAL)
	
		move_and_slide()

func _process(delta):
	if health <= 0:
		self.queue_free()

func damage():
	anim.play("hit")
	health -= 2
	set_physics_process(false)
	$StopAfterCombat.start()

func _on_attack_sensor_body_entered(body):
	if body.is_in_group("Player"):
		set_physics_process(true)

func enemy_ai(delta):
	while not player_dead:
		if not first_step_done:
			enemy_ai_step_1(delta)
		if not step_2_done and first_step_done:
			enemy_ai_step_2()
			$WaitToCharge.start()
		
		enemy_ai_step_3(delta)
		
		if step_3_done and not hit_player:
			enemy_ai_reset()
			continue
		else:
			break

func enemy_ai_step_1(delta): #move back and stop once far enough
	var translation_vector = Vector3(0, 0, move_back_speed * delta)
	var relative_pos = body.transform.origin.z - target.transform.origin.z
	
	if relative_pos >= -18:
		body.translate(translation_vector)
		colider.translate(translation_vector)
		area_colider.translate(translation_vector)
	else: 
		translation_vector = Vector3(0, 0, 0)
		first_step_done = true
		return

func enemy_ai_step_2(): #rotate to look at the player 
	if not already_rotated_for_combat_2 and first_step_done:
		body.rotate_y(140)
		already_rotated_for_combat_2 = true
	
	if already_rotated_for_combat_2:
		step_2_done = true
		return

func enemy_ai_step_3(delta):
	if step_2_done and can_charge:
		var target_direction = (target.transform.origin - transform.origin).normalized()
		velocity = -target_direction * charge_towrds_player_speed
		move_and_slide()
		step_3_done = true
		return

func enemy_ai_reset():
	first_step_done = false
	step_2_done = false
	step_3_done = false
	can_charge = false

	# Reset the enemy's position and rotation
	body.transform.origin = initial_position
	body.rotation.y = initial_rotation

	# Stop the enemy's movement
	velocity = Vector3.ZERO
	move_and_slide()

func _on_stop_after_combat_timeout():
	set_physics_process(true)

func _on_charge_damage_sensor_body_entered(body):
	if body.is_in_group("Player"):
		hit_player = true
		events.emit_signal("one_hit")

func _on_wait_to_charge_timeout():
	can_charge = true
