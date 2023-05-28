extends Sprite

func _enter_tree():
	$AnimationPlayer.play("Run")

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
