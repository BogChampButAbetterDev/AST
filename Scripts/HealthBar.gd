extends Control

func _ready():
	events.update_healthbar.connect(update_health_bar)

func update_health_bar():
	player_damaged(20)

func player_damaged(damage):
	if $ProgressBar.value < damage:
		damage = $ProgressBar.value
	$ProgressBar.value -= damage
