extends CharacterBody3D

var speed = 3.0
@onready var target = $"../Player"
@onready var body = $body
var health = 10

const LERP_VAL = .15

func _ready():
	events.enemy_damaged.connect(damage)

func _physics_process(delta):
	var target_direction = (target.transform.origin - transform.origin).normalized()
	var desired_rotation = atan2(-target_direction.z, target_direction.x)
	
	if target == null: get_tree().get_nodes_in_group("Player")[0]
	
	if not is_on_floor():
		velocity.y -= 15 * delta
	
	if target != null: 
		velocity = transform.origin.direction_to(target.transform.origin) * speed
		
		if velocity:
			body.rotation.y = lerp_angle(body.rotation.y, desired_rotation, LERP_VAL)
			
		move_and_slide()

func _process(delta):
	print(health)
	if health == 0:
		self.queue_free()

func damage():
	health -= 2
