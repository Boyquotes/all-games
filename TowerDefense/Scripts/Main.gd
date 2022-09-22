extends Node2D

const LIMITS = [-160, 160]

var enemies_to_spawn:int = ceil(8*pow(Global.INFOS['actual_round'], 0.5))

var actual_highest_enemy_type = [0, 0]
var SPAWNS = [ceil(enemies_to_spawn/10.0), ceil(enemies_to_spawn/5.0), ceil(enemies_to_spawn/2.5), ceil(enemies_to_spawn/5.0), ceil(enemies_to_spawn/10.0)]

func _ready():
	Global.INFOS['actual_life'] = Global.INFOS['max_life']
	Global.INFOS['round'] = 1
	#for z in 20:
	#	for x in 20:
	#		var node = preload("res://Scenes/Tile.tscn").instance()
	#		node.global_position = Vector2(z*16, x*16)
	#		$Grid.call_deferred("add_child", node)
	if Global.CONFIGURATIONS['autopass'] == true:
		$SpawnEnemies.start()

func _process(_delta):
	if Input.is_action_just_pressed("SHIFT"):
		var node = preload("res://Scenes/Enemy.tscn").instance()
		node.global_position = Vector2(-80, 24)
		$Enemies.call_deferred("add_child", node)
	if Input.is_action_just_pressed("K"):
		for z in get_tree().get_nodes_in_group("ENEMY"):
			z.INFOS['health'] = 0
			yield(get_tree().create_timer(0.5), "timeout")


var abacate = 0

func GenerateTile(type = null, posi = null):
	abacate += 1
	var DIRECTIONS = {#Right, Bottom, Up, Left
		'0': ['R', 'B'],
		'1': ['L', 'B', 'R'],
		'2': ['L', 'B'],
		'4': ['T', 'R', 'B'],
		'5': ['T', 'L', 'R', 'B'],
		'6': ['T', 'L', 'B'],
		'7': ['T', 'B'],
		'8': ['T', 'R'],
		'9': ['L', 'T', 'R'],
		'10': ['L', 'T'],
		'11': ['L', 'R'],
	}
	var POSSIBILITIES = {
		'R': ['1', '2', '5', '6', '9', '10', '11', '13'],
		'B': ['4', '5', '6', '7', '8', '9', '10', '15'],
		'T': ['0', '1', '2', '4', '5', '6', '7', '14'],
		'L': ['0', '1', '4', '5', '8', '9', '11', '12'],
	}
	var ADDICTIONS = {
		'R': [16, 0],
		'L': [-16, 0],
		'T': [0, -16],
		'B': [0, 16],
	}
	if abacate < 1000:
		for DIRS in DIRECTIONS[type]:
			var GO = true
			for z in get_tree().get_nodes_in_group("TILE"):
				if z.global_position == Vector2(posi[0]+ADDICTIONS[DIRS][0], posi[1]+ADDICTIONS[DIRS][1]):
					GO = false
					break
			if posi[0]+ADDICTIONS[DIRS][0] < LIMITS[0] and posi[0]+ADDICTIONS[DIRS][0] > LIMITS[1] and posi[1]+ADDICTIONS[DIRS][1] < LIMITS[0] and posi[1]+ADDICTIONS[DIRS][1] > LIMITS[1]:
				GO = false
			if len(get_tree().get_nodes_in_group("TILE")) == 5:
				GO = false
			if GO == true:
				var node = preload("res://Scenes/Tile.tscn").instance()
				node.TYPE = POSSIBILITIES[DIRS][Global.RAND.randi_range(0, len(POSSIBILITIES[DIRS])-1)]
				node.global_position = Vector2(posi[0]+ADDICTIONS[DIRS][0], posi[1]+ADDICTIONS[DIRS][1])
				$Grid.call_deferred("add_child", node)
				print(len(get_tree().get_nodes_in_group("TILE")))


func PassTurn():
	if actual_highest_enemy_type[0]+1 > Global.MAX_ENEMY_X_TYPE:
		actual_highest_enemy_type = [0, actual_highest_enemy_type[1]+1]
	elif actual_highest_enemy_type[1]+1 > Global.MAX_ENEMY_Y_TYPE:
		actual_highest_enemy_type = [Global.MAX_ENEMY_X_TYPE, Global.MAX_ENEMY_Y_TYPE]
	else:
		actual_highest_enemy_type = [actual_highest_enemy_type[0]+1, actual_highest_enemy_type[1]]
	Global.INFOS['actual_round'] += 1
	Global.INFOS['gears'] += ceil(Global.INFOS['gears_per_round']+Global.INFOS['boost_gears_per_round']*Global.INFOS['actual_round'])
	enemies_to_spawn = ceil(8*pow(Global.INFOS['actual_round'], 0.5))
	SPAWNS = [ceil(enemies_to_spawn/10.0), ceil(enemies_to_spawn/5.0), ceil(enemies_to_spawn/2.5), ceil(enemies_to_spawn/5.0), ceil(enemies_to_spawn/10.0)]
	$SpawnEnemies.start()

func _on_SpawnEnemies_timeout():
	var index = 4
	var enems = SPAWNS[index]
	if enems == 0:
		for _z in range(0, 5):
			index -= 1
			enems = SPAWNS[index]
			if enems != 0:
				break
	if enems > 0:
		var node = preload("res://Scenes/Enemy.tscn").instance()
		node.global_position = Vector2(-80, 24)
		node.TYPE_X = actual_highest_enemy_type[0]+index-4
		node.TYPE_Y = actual_highest_enemy_type[1]
		$Enemies.call_deferred("add_child", node)
		SPAWNS[index] -= 1
		$SpawnEnemies.start()
	else:
		$SpawnEnemies.stop()
		if Global.CONFIGURATIONS['autopass'] == true:
			#PassTurn()
			pass
