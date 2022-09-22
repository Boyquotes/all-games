extends Sprite

func _process(_delta):
	if len(get_tree().get_nodes_in_group("ITEM")) > 0:
		visible = true
		var nearest = null
		var distances = []
		for z in get_tree().get_nodes_in_group("ITEM"):
			distances.append(self.global_position.distance_to(z.global_position))
		nearest = get_tree().get_nodes_in_group("ITEM")[distances.find(distances.min())].global_position
		look_at(nearest)
	else:
		visible = false
