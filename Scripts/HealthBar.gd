extends Control

func _ready():
	events.update_healthbar.connect(update_health_bar)
	events.collected_apple.connect(other_hb_update)

func update_health_bar():
	player_damaged(20)

func other_hb_update():
	heal_player(5)

func player_damaged(damage):
	if $ProgressBar.value < damage:
		damage = $ProgressBar.value
	$ProgressBar.value -= damage

func heal_player(value):
	if $ProgressBar.value > value:
		value = $ProgressBar.value
	$ProgressBar.value += value
