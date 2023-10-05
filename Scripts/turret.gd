extends Node3D

func _ready():
	events.shoot.connect(shoot)

func shoot():
	$AnimationPlayer.play("shoot")

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		events.emit_signal("damage_player")
		events.emit_signal("update_healthbar")
		
	if body.is_in_group("dungin"):
		get_parent().get_parent().queue_free()
