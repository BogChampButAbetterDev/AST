extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_button_button_down():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_button_2_button_down():
	get_tree().quit()
