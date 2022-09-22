extends Node2D

var num = 1

func _ready():
	Global.RANDOM.randomize()
	var X = Global.RANDOM.randi_range(0, 2)
	Global.RANDOM.randomize()
	var Y = Global.RANDOM.randi_range(0, 2)
	if X == 0:
		X = 1
	else:
		X = -1
	if Y == 0:
		Y = 1
	else:
		Y = -1
	Global.RANDOM.randomize()
	var rand = Global.RANDOM.randf_range(0, 1)+0.25
	set_scale(Vector2(rand, rand))
	Global.RANDOM.randomize()
	global_position = Vector2(global_position[0] + ((Global.RANDOM.randf_range(0, 1)+0.25*6)*X), global_position[1] + ((Global.RANDOM.randf_range(0, 1)+0.25*6))*Y)
	
	while num > 0:
		self.set_modulate(Color(1, 1, 1, num-0.1))
		num -= 0.1
		yield(get_tree().create_timer(0.2), "timeout")
	queue_free()
