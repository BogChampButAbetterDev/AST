extends StaticBody3D

func _ready():
	events.slash.connect(sword_slashed)
	$CollisionShape3D.disabled = true #player can't sprint if enabled

func sword_slashed():
	$CollisionShape3D.disabled = false #only re-enable if player attacks
	$AnimationPlayer.play("slash")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'slash':
		$CollisionShape3D.disabled = true
