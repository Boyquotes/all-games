extends Node2D

func SET_ASTEROID():
	while Global.PLAYER_INFOS['actual_health']>0:
		var node = preload("res://Scenes/Items/Asteroid.tscn").instance()
		Global.RANDOM.randomize()
		node.global_position = Vector2(Global.RANDOM.randi_range(0, 1000), Global.RANDOM.randi_range(0, 1000))
		add_child(node)
		yield(get_tree().create_timer(30), "timeout")

func _ready():
	SET_ASTEROID()
	var node = preload("res://Scenes/Dialog/DialogScene.tscn").instance()
	node.dialogo = 'start'
	call_deferred("add_child", node)

