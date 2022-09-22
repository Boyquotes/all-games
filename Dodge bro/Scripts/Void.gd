extends Sprite

func _ready():
	Global.set_process_bit(self, false)
	var index:float = 1.0
	for z in 100:
		set_modulate(Color(1, 1, 1, index))
		index -= 0.01
		yield(get_tree().create_timer(0.01), "timeout")
	queue_free()
