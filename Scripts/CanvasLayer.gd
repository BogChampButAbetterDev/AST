extends CanvasLayer

func _ready():
	events.show_key_needed_text.connect(show_text_key)

func show_text_key():
	$Label2.show()
