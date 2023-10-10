extends StaticBody3D

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		events.emit_signal("picked_up_key")
		events.emit_signal("update_key_counter")
		queue_free()
