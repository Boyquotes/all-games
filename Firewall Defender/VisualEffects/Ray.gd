extends Node2D

var to_position

func build_trail():
	var difference = (to_position.y - global_position.y) / 16
	
	for z in range(1, difference):
		var new_trail = Sprite.new()
		new_trail.texture = preload("res://Images/VisualEffects/Ray_trail.png")
		
		add_child(new_trail)
		
		new_trail.global_position = Vector2(global_position.x, global_position.y + (z * 16))

func _enter_tree():
	build_trail()
	
	$AnimationPlayer.play("Run")

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
