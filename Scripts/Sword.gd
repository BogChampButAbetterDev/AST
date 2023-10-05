extends StaticBody3D

var valid_damage = false

func _ready():
	events.slash.connect(sword_slashed)

func sword_slashed():
	$AnimationPlayer.play("slash")
	valid_damage = true

func _on_area_3d_body_entered(body):
	if body.is_in_group("Enemy") and valid_damage:
		events.emit_signal("enemy_damaged")
