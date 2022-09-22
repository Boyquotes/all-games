extends Node2D
var RANDOM = RandomNumberGenerator.new()

var MOLECULAS = ['H', 'He', 'Al']
var CORES = {
	'H': Color(0, 0, 1),
	'He': Color(0, 1, 0),
	'Al': Color(1, 0, 0),
}

var PLAYER_INFOS = {
	'multiplicador': 1,
	'asteroid_level': 1,
	'asteroid_variety': 1,
	'planets': [],
}

#planetas: gasosos, líquidos, sólidos e os 3 juntos
var PLANETS = {
	'Solido': 0,
	'Liquido': 0,
	'Gasoso': 0,
	'Life': 0,
}

#gasosoLvl5 = sun
#liquidoLvl5 = 
#solidoLvl5 = 

var ITEM_BY_TYPE = {
	#[entra, sai]
	'Gasoso': ['He', 'O'],
	'Solido': ['Al', 'Fe'],
	'Liquido': ['H', 'Cl'],
	
	'Life': ['C', 'He', 'Al', 'Cl'],
}

var INVENTORY = {
	'H': 100,
	'He': 100,
	'Al': 100,
	
	'O': 0,
	'Fe': 0,
	'Cl': 0,
	
	'C': 0,
}

func _ready():
	RANDOM.randomize()
	ObjectPoolManager.register_obj("Asteroid", "res://Scenes/Asteroid.tscn")
	ObjectPoolManager.register_obj("Planet", "res://Scenes/Planets.tscn")

func SET_RANDOM_ITEM(node):
	node.nome.clear()
	node.quantidade.clear()
	for z in PLAYER_INFOS['asteroid_variety']:
		var molecula = MOLECULAS[RANDOM.randi_range(0, len(MOLECULAS)-1)]
		node.nome.append(molecula)
		node.quantidade.append(PLAYER_INFOS['asteroid_level']*RANDOM.randi_range(1, 6))
		node.find_node('Button').set_modulate(CORES[molecula])

func KILL(who):
	for z in range(0, len(who.nome)):
		INVENTORY[who.nome[z]] += who.quantidade[z]
		if len(get_tree().get_nodes_in_group("INVENTORY")[0].get_children()) == 0:
			var node = preload("res://Scenes/INV_SLOT.tscn").instance()
			node.find_node('Item').text = who.nome[z]
			node.find_node("Value").text = str(INVENTORY[who.nome[z]])
			get_tree().get_nodes_in_group("INVENTORY")[0].add_child(node)
		else:
			var found = false
			for x in get_tree().get_nodes_in_group("INVENTORY")[0].get_children():
				if x.find_node("Item").text == who.nome[z]:
					x.find_node("Value").text = str(INVENTORY[who.nome[z]])
					found = true
					break
			if found == false:
				var node = preload("res://Scenes/INV_SLOT.tscn").instance()
				node.find_node('Item').text = who.nome[z]
				node.find_node("Value").text = str(INVENTORY[who.nome[z]])
				get_tree().get_nodes_in_group("INVENTORY")[0].add_child(node)
	if get_tree().get_nodes_in_group("MAIN")[0].find_node('AnimationPlayer').is_playing() == false:
		get_tree().get_nodes_in_group("MAIN")[0].find_node('AnimationPlayer').play('ItemAdded')
	ObjectPoolManager.destroy(who.get_instance_id())
