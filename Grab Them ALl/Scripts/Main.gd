extends Node2D

func _process(_delta):
	if Input.is_action_pressed("ui_left"):
		if $Player/Sprite.global_position[0] > 32:
			$Player/Sprite.global_position[0] -= 2
	if Input.is_action_pressed("ui_right"):
		if $Player/Sprite.global_position[0] < 1248:
			$Player/Sprite.global_position[0] += 2

func _on_Timer_timeout():
	var Random = RandomNumberGenerator.new()
	Random.randomize()
	var node = preload("res://Scenes/FallingItem.tscn").instance()
	
	$Fall.add_child(node)
	node.global_position[1] = -32
	node.global_position[0] = Random.randi_range(32, 1280)

func _on_Area2D_area_entered(area):
	area = area.get_parent()
	if area.is_in_group("FallingItem"):
		var node = preload("res://Scenes/InfoLabel.tscn").instance()
		node.text = '+'+str(area.INFOS['value'])
		$InfoLabel.add_child(node)
		node.set_position(area.global_position)
		area.queue_free()
