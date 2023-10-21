extends CanvasLayer

func _ready():
	events.show_key_needed_text.connect(show_text_key)
	events.show_need_sword_text.connect(snst)
	print('signals connected')

func show_text_key():
	print('key text shown')
	$Label2.show()
	$lab2timer.start()

func snst(): #show need sword text
	print('sword text shown')
	change_label_two('You need a sword to go in there!')
	$Label2.show()
	$lab2timer.start()

func change_label_two(text):
	$Label2.text = text

func _on_lab_2_timer_timeout():
	$Label2.hide()
	change_label_two('You need a key to go in there!')
