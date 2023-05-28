extends Node2D

var amount_earned = 0

func _enter_tree():
	$Label.text = str(amount_earned)
	
	$AnimationPlayer.play("Run")

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
