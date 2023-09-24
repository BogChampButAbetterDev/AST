extends CharacterBody3D

var SPEED : float = 5.0
const JUMP_VELOCITY : float = 4.5

const MOUSE_SENSITIVITY : float = .005

const LERP_VAL : float = .15

var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var body := $body
@onready var spring_arm_pivot := $"Spring Arm Pivot"
@onready var spring_arm := $"Spring Arm Pivot/SpringArm3D"
@onready var sword := $Sword

var health : int = 10

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	events.damage_player.connect(take_damage)

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_end"):
		get_tree().quit()
	
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		spring_arm.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/2, -PI/-2)
	
	if event is InputEventMouseButton:
		events.emit_signal("slash")

func _process(delta):
	print(health)
	if health <= 0:
		get_tree().change_scene_to_file("res://Scenes/control.tscn")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir = Input.get_vector("d", "a", "s", "w")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	
	if direction:
		velocity.x = -direction.x * SPEED
		velocity.z = -direction.z * SPEED
		
		body.rotation.y = lerp_angle(body.rotation.y, atan2(velocity.x, velocity.z), LERP_VAL)
		if Input.is_action_pressed("sprint"):
			SPEED = 10.0
		else:
			SPEED = 5.0
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func take_damage():
	health -= 2
