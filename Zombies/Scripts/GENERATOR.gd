extends Timer

func _on_SPAWNER_timeout():
	var possibilities = []
	var nodes = []
	for z in get_tree().get_nodes_in_group("CHAR"):
		for x in get_tree().get_nodes_in_group("SPAWNER"):
			possibilities.append(x.global_position.distance_to(z.global_position))
			nodes.append(x.global_position)
	if len(get_tree().get_nodes_in_group("ENEMY")) <= 30:
		Global.SPAWN(nodes[possibilities.find(possibilities.min())])
	start()
