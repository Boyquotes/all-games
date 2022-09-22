extends Node2D

func _ready():
	for z in range(0, Global.PLAYER_DATA['MAX_INVENTORY_SIZE']):
		ADD_SLOT(z)
	$GridContainer/PLAYER/INFOS/LEVEL.text = 'LEVEL: '+ str(Global.PLAYER_DATA['LEVEL'])+'\n'+ str(Global.PLAYER_DATA['NATION'])+'\n'+ str(Global.PLAYER_DATA['CLASS'])

func ADD_SLOT(index):
	var node = preload("res://Scenes/SLOT.tscn").instance()
	if Global.PLAYER_DATA['INVENTORY'][index] != null:
		node.texture = load(Global.PLAYER_DATA['INVENTORY'][index][12])
	else:
		node.texture = preload("res://icon.png")
	get_tree().get_nodes_in_group("INVENTORY")[0].add_child(node)

func SET_ACT(type):
	var node = preload("res://Scenes/Specific_scenes/SPECIFIC_SCENE_TEMPLATE.tscn").instance()
	node.SCENE = type
	$GridContainer/ACTION.add_child(node)
