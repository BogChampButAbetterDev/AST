extends StaticBody3D

var sword_collected = false

func _ready():
	events.sword_collected.connect(set_sword_collected)

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player") and sword_collected:
		events.emit_signal("can_open_door")
	elif body.is_in_group("Player") and not sword_collected:
		print('balls')
		events.show_need_sword_text.emit()

func set_sword_collected():
	sword_collected = true
