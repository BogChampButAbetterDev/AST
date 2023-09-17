extends StaticBody3D

var check_valid_damage = false

func _ready():
	events.slash.connect(sword_slashed)

func sword_slashed():
	$AnimationPlayer.play("slash")

func _on_area_3d_body_entered(body):
	if body.is_in_group("enemy"):
		events.emit_signal("enemy_damaged")
