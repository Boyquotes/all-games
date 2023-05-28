extends Node2D

func play_anim():
	$AnimatedSprite.play("default")

func _on_AnimatedSprite_animation_finished():
	get_parent().queue_free()
