extends CanvasLayer

var number_of_keys : int = 0 

func _ready():
	$keyCounter.text = "Keys: " + str(number_of_keys)
	events.update_key_counter.connect(update_key_counter)

func update_key_counter():
	number_of_keys += 1
	$keyCounter.text = "Keys: " + str(number_of_keys)
