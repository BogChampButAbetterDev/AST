extends StaticBody3D

#when player picks up a key, can_open will be set to true
#when the player walks up to the door, it checks if can_open is true
#if it is, the door will (physics process gets turned back on)
#else it prints balls (atleast for now)
#this scripts uses te picked up key signal

var can_open = false

func _ready():
	set_physics_process(false)
	events.picked_up_key.connect(check_can_open)

func _physics_process(delta):
	var translation_vector : Vector3 = Vector3(0, 20, 0)
	translate(translation_vector)
	if translation_vector.y > 100:
		self.queue_free()

func check_can_open():
	can_open = true #when this function is called player will have a key

func open():
	print(open)
	set_physics_process(true)

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		match can_open:
			true:
				open()
			false:
				events.emit_signal("show_key_needed_text")
