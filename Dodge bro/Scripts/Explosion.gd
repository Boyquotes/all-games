extends AnimatedSprite

func _enter_tree():
	play('a')

func _on_Explosion_animation_finished():
	stop()
	visible = false
	Global.EXPLOSION_POOL.append(self)
	get_parent().call_deferred("remove_child", self)
