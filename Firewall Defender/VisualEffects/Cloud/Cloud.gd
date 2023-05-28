extends Node2D

const TEXTURES = ["res://Images/Backgrounds/Parallax/Nuvem1.png", "res://Images/Backgrounds/Parallax/Nuvem2.png", "res://Images/Backgrounds/Parallax/Nuvem3.png"]

func _enter_tree():
	$Sprite.texture = load(TEXTURES[Global.RANDOM.randi_range(0, len(TEXTURES)-1)])

func _on_Timer_timeout():
	global_position.x += 1
	
	if global_position.x != 1400:
		$Timer.start()
	else:
		queue_free()
