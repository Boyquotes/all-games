extends Node2D

const OBJ_INFO = {
	#  [pos, pos, pos, pos, cost(in US$)]
	'2': [1, 0, 1, 0, 2],
	'16': [0, 0, 0, 0, 8]
}

var PLAYER_INFOS = {
	'potencia_computacional_atual': 0,
	'actual_processor_cost': 0,
}


var MAX_X = 199.9
var MIN_X = -207.9

var MIN_Y = -207.9
var MAX_Y = 199.9

var ENERGY_POOL = []

func _process(_delta):
	if len(ENERGY_POOL) != 0:
		for x in get_tree().get_nodes_in_group("ENERGY_CABLE"):
			if x.global_position == Vector2(ENERGY_POOL[0].global_position[0]-8, ENERGY_POOL[0].global_position[1]) or x.global_position == Vector2(ENERGY_POOL[0].global_position[0]+8, ENERGY_POOL[0].global_position[1]) or x.global_position == Vector2(ENERGY_POOL[0].global_position[0], ENERGY_POOL[0].global_position[1]-8) or x.global_position == Vector2(ENERGY_POOL[0].global_position[0], ENERGY_POOL[0].global_position[1]+8):
				if x.ENERGY == false:
					for z in get_tree().get_nodes_in_group("OBJ"):
						if z.get_name() != 'Energy_provider':
							for y in OBJ_INFO[str(len(z.POINTS))]:
								if z.POINTS[OBJ_INFO[str(len(z.POINTS))][z.rotation_degrees/90]] == x.global_position:
									z.ENERGY = true
									z.find_node("AREA").color = Color(0.937255, 0.937255, 0.937255)
									break
					x.ENERGY = true
					x.find_node("AREA").color = Color(0.07451, 0.129412, 0.290196)
					x.remove_from_group("ENERGY_CABLE")
					ENERGY_POOL.append(x)
		ENERGY_POOL.remove(0)

func ANALYSE_POSITION(node, last_pos, kill=false):
	var can = true
	for z in get_tree().get_nodes_in_group("OBJ"):
		if can == false:
			break
		if z != node:
			for node_points in node.POINTS:
				if can == false:
					break
				for z_points in z.POINTS:
					if node_points == z_points:
						if kill == true:
							node.queue_free()
							Global.PLAYER_INFOS[node.TYPE]-=1
							Global.PLAYER_INFOS['actual_processor_cost']-=OBJ_INFO[str(len(node.POINTS))][4]
						else:
							node.global_position = last_pos
						can = false
						break
						return false
	for z in node.POINTS:
		if z[0]<MIN_X or z[0]>MAX_X or z[1]<MIN_Y or z[1]>MAX_Y:
			if kill == true:
				node.queue_free()
				Global.PLAYER_INFOS[node.TYPE]-=1
				Global.PLAYER_INFOS['actual_processor_cost']-=OBJ_INFO[str(len(node.POINTS))][4]
			else:
				node.global_position = last_pos
			break
			return false
	return true

func DRAG_ITEM(node):
	node.set_z_index(9)
	var X = stepify(get_global_mouse_position()[0]-node.find_node("AREA").get_size()[0]/2, 8)
	var Y = stepify(get_global_mouse_position()[1]-node.find_node("AREA").get_size()[1]/2, 8)
	node.global_position = Vector2(X, Y)

func RETURN_POINTS(node):
	var POINTS = []
	for x in (node.find_node("AREA").get_size()[0]/8):
		for y in (node.find_node("AREA").get_size()[1]/8):
			match int(node.rotation_degrees/90):
				0:
					POINTS.append(Vector2(node.global_position[0]+(8*x), node.global_position[1]+(8*y)))
				1:
					POINTS.append(Vector2((node.global_position[0]-node.find_node("AREA").get_size()[1])+(8*y), node.global_position[1]+(8*x)))
				2:
					POINTS.append(Vector2((node.global_position[0]-node.find_node("AREA").get_size()[0])+(8*x), (node.global_position[1]-node.find_node("AREA").get_size()[1])+(8*y)))
				3:
					POINTS.append(Vector2(node.global_position[0]+(8*y), (node.global_position[1]-node.find_node("AREA").get_size()[0])+(8*x)))
	return POINTS
