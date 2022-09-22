extends Label

func _ready():
	var index = 1
	while index != 0:
		set_modulate(Color(1, 1, 1, index))
		_set_position(Vector2(get_position()[0], get_position()[1]-1))
		index -= 0.1
		yield(get_tree().create_timer(0.1), "timeout")
	queue_free()
