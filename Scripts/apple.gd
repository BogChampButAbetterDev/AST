extends Node3D

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		events.emit_signal("collected_apple")
		self.queue_free()
