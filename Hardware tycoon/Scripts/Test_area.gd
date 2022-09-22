extends Node2D

func _process(_delta):
	if Input.is_action_just_pressed("WHEEL_DOWN"):
		$Camera2D.zoom = Vector2($Camera2D.zoom[0]-0.1, $Camera2D.zoom[1]-0.1)
		$Camera2D.set_scale(Vector2($Camera2D.get_scale()[0]-0.1, $Camera2D.get_scale()[1]-0.1))
	if Input.is_action_just_pressed("WHEEL_UP"):
		$Camera2D.zoom = Vector2($Camera2D.zoom[0]+0.1, $Camera2D.zoom[1]+0.1)
		$Camera2D.set_scale(Vector2($Camera2D.get_scale()[0]+0.1, $Camera2D.get_scale()[1]+0.1))
	if Input.is_action_pressed("E"):
		var node_list = GENERATE_NODE("res://Scenes/OBJS/ENERGY_CABLE.tscn")
		var node = node_list[0]
		if len(get_tree().get_nodes_in_group("ENERGY_CABLE")) == 0:
			$OBJS.add_child(node)
		var a = true
		for z in get_tree().get_nodes_in_group("ENERGY_CABLE"):
			if z != node:
				if z.global_position == Vector2(node_list[1], node_list[2]):
					node.queue_free()
					a = false
					break
		if a == true and node.get_parent() == null:
			$OBJS.add_child(node)
	if Input.is_action_pressed("B"):
		var node_list = GENERATE_NODE("res://Scenes/OBJS/Transistor.tscn")
		var node = node_list[0]
		node.TYPE = 'potencia_computacional_atual'
		$OBJS.add_child(node)
		node.global_position = Vector2(node_list[1], node_list[2])
		node.set_z_index(1)
		node.POINTS = Global.RETURN_POINTS(node)
		Global.ANALYSE_POSITION(node, node.global_position, true)
	if Input.is_action_just_pressed("X"):
		for z in get_tree().get_nodes_in_group("ENERGY_CABLE"):
			z.queue_free()
			Global.PLAYER_INFOS['actual_processor_cost'] -= 0.25
	var input_dir: Vector2 = Vector2.ZERO
	input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_dir = input_dir.normalized()
	if input_dir != Vector2.ZERO:
		$Camera2D.global_position += input_dir*(10-(Input.get_action_strength("SHIFT")*7))
	$INFOS/Label.text = 'Potência computacional: '+str(Global.PLAYER_INFOS['potencia_computacional_atual'])+'\n'+'Custo do Processador: '+str(Global.PLAYER_INFOS['actual_processor_cost'])

func _on_ENERGY_toggled(button_pressed):
	if button_pressed == true:
		for z in get_tree().get_nodes_in_group("ENERGY_PROVIDER"):
			var min_x = z.find_node("ENERGY").get_global_position()[0]
			var max_x = z.find_node("ENERGY").get_global_position()[0]+z.find_node("ENERGY").get_size()[0]
			
			var min_y = z.find_node("ENERGY").get_global_position()[1]
			var max_y = z.find_node("ENERGY").get_global_position()[1]+z.find_node("ENERGY").get_size()[1]
			for x in get_tree().get_nodes_in_group("ENERGY_CABLE"):
				if x.global_position[0]>=min_x and x.global_position[0]<max_x and x.global_position[1]>=min_y and x.global_position[1]<max_y:
					x.ENERGY = true
					x.remove_from_group("ENERGY_CABLE")
					x.find_node("AREA").color = Color(0.07451, 0.129412, 0.290196)
					Global.ENERGY_POOL.append(x)
	else:
		for z in get_tree().get_nodes_in_group("CABLE"):
			z.ENERGY = false
			z.add_to_group("ENERGY_CABLE")
			z.find_node("AREA").color = Color(0.290196, 0.07451, 0.07451)
			Global.ENERGY_POOL.clear()
		for z in get_tree().get_nodes_in_group("OBJ"):
			z.ENERGY = false
			if z.get_name() != 'Energy_provider':
				z.find_node("AREA").color = Color(0.560784, 0.560784, 0.560784)


func GENERATE_NODE(scene: String):
	var node = load(scene).instance()
	node.set_z_index(10)
	var X = stepify(get_global_mouse_position()[0], 8)
	var Y = stepify(get_global_mouse_position()[1], 8)
	if X < Global.MIN_X:
		X = Global.MIN_X
	if X > Global.MAX_X-node.find_node("AREA").get_size()[0]:
		X = Global.MAX_X-node.find_node("AREA").get_size()[0]
	if Y < Global.MIN_Y:
		Y = Global.MIN_Y
	if Y > Global.MAX_Y-node.find_node("AREA").get_size()[1]:
		Y = Global.MAX_Y-node.find_node("AREA").get_size()[1]
	if get_global_mouse_position()[0]<X:
		X -= 8
	if get_global_mouse_position()[1]<Y:
		Y -= 8
	node.global_position = Vector2(X, Y)
	return [node, X, Y]

func _on_TRANSISTORS_button_up():
	for z in get_tree().get_nodes_in_group("TRANSISTOR"):
		Global.PLAYER_INFOS[z.TYPE] -= 1
		Global.PLAYER_INFOS['actual_processor_cost'] -= Global.OBJ_INFO[str(len(z.POINTS))][4]
		z.queue_free()
