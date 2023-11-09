extends Control

var selecting_map = false

func _on_youtube_link_button_down():
	OS.shell_open("https://www.youtube.com/@AShortTail")

func _on_play_button_down():
	get_tree().change_scene_to_file("res://Scenes/lost_forest_playable.tscn")
