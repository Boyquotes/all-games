extends Node2D

func _enter_tree():
	var X = Global.RANDOM.randf_range(0, 1)
	var index = 1
	set_modulate(Color(1, 1, 1, index))
	for z in 50:
		index-=0.02
		global_position += Vector2(X, -1)
		set_modulate(Color(1, 1, 1, index))
		yield(get_tree().create_timer(0.01), "timeout")
	Global.DMG_LABEL_POOL.append(self)
	get_parent().remove_child(self)
