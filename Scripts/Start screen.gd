extends Control

var selecting_map = false

func _on_youtube_link_button_down():
	OS.shell_open("https://www.youtube.com/@AShortTail")

func _on_play_button_down():
	$Play.hide()
	$"youtube link".hide()
	$Label.text = "Select Adventure"
	selecting_map = true
	$DemoDungeon.show()
	$TestMap.show()

func _on_demo_dungeon_button_down():
	if selecting_map:
		get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_test_map_button_down():
	if selecting_map:
		get_tree().change_scene_to_file("res://Scenes/test_scene.tscn")
