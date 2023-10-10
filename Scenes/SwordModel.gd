extends Node3D

#ONLY EMITS THE VALID DAMAGE SIGNAL

func _on_area_3d_body_entered(body):
	if body.is_in_group("Enemy"):
		events.emit_signal("valid_damage")
