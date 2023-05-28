extends Node

#####GAME INFOS

#o tamanho da cobra não tem relação com a vida

#shield, armor, vida, dano físico (bate em armor), dano mágico (bate em shield)

#exp ->
#	matar o inimigo dá xp
#	a cada nível o jogador escolhe entre 1 de shield, 1 de armor, 1 de vida, 1 de dano físico ou 1 de dano mágico
#	o nível dos inimigos da próxima sala também aumenta

#dinheiro ->
#	alguns inimigos dão dinheiro quando mortos
#	é possível quebrar vasos para encontrar dinheiro
#	é possível gastar dinheiro na sala do shop ->
#		é possível comprar melhorias de vida, shield, armor, diminuir o tamanho da cobra, dano físico, dano mágico

#salas ->
#	salas de puzzle
#	salas de combate
#	salas de shop
#	sala da fonte

#a fonte ->
#	te permite escolher gratuitamente um buff após alguns combates um pouco difíceis

#puzzles ->
#	tem que ser procedurais mas com linha de resolução fixa

#combate ->
#	no início do combate é rolado um dado para saber qual atributo será o determinante para o primeiro atacar (armor, shield, vida, atk fisico, atk magico) quem tiver o maior atributo começa atacando
#	defender ataque (automaticamente usa a defesa certa para o tipo do ataque)
#	atacar físico
#	atacar mágico
#	o jogador sempre enfrentará apenas 1 inimigo por vez, mesmo que este seja um grupo de inimigos (ex: gangue de ratos)

#####GAME INFOS

const TEXTURES = {
	'Armor': "res://Textures/Icons/Armor.png",
	'DmgFis': "res://Textures/Icons/Atk_Fis.png",
	'DmgMag': "res://Textures/Icons/Atk_Mag.png",
	'Coin': "res://Textures/Icons/Coin.png",
	'Down': "res://Textures/Icons/Down.png",
	'Exp': "res://Textures/Icons/EXP.png",
	'Health': "res://Textures/Icons/Health.png",
	'Level': "res://Textures/Icons/Level.png",
	'Shield': "res://Textures/Icons/Shield.png",
	'SnakeLen': "res://Textures/Icons/SnakeLenIcon.png",
	'Up': "res://Textures/Icons/Up.png",
	'WhiteCircle32': "res://Textures/Icons/WhiteCircle32.png",
	'BlackX': "res://Textures/Icons/BlackX.png",
}

const JUMP_DISTANCE = 16
var RANDOM = RandomNumberGenerator.new()

var ACTUAL_ROOMS_LIST = []
var ACTUAL_PATH = []

const COLLIDER_COLORS = [Color(1, 1, 1), Color(0, 0,1), Color(0, 0,1), Color(0, 0,1), Color(0, 0,1), Color(1, 1, 0), Color(1, 0, 0), Color(0.25, 0, 0.25), Color(0.8125, 0.571289, 0), Color(0.5, 0.2, 0.7, 0.5), Color(0.5, 0.5, 0.5), Color(0.447059, 0.219608, 0)]
const COLLIDER_EXPLANATIONS = []

var ROOMS_SPAWNED = 0

var SHOP_BUFFER = 0#each 10 rooms apears a shop
var LAST_OBJECTIVE = ''

var ActualShopItemValue = 5#Aumenta em 1 para cada item comprado

var PRE_GAME = {
	'initial_exp': 5,
	'initial_coins': 0,
}

var UPGRADES = {
	'max_coins_per_room': 2,
	'max_enemies_per_room': 5,
	'max_exp_per_room': 5,
	'max_traps_per_room': 2,
}

onready var SNAKE = get_tree().get_nodes_in_group("SnakeHead")[0]
onready var GAME = get_tree().get_nodes_in_group("GAME")[0]

func ReturnAll():
	return [get_tree().get_nodes_in_group("Collider"), [SNAKE], SNAKE.Parts]

const ENEMY_BUILDING = {
	'easy': [
		[0, 3],
		[0, 3],
		[0, 3],
		[0, 3],
		[1, 6],
		true,
		[0, 3],
		1,#máximo boost extra para cada atributo
		0.75,#máximo multiplicador para cada atributo
	],
	'medium': [
		[0, 5],
		[0, 5],
		[0, 5],
		[0, 5],
		[2, 10],
		true,
		[0, 5],
		2,#máximo boost extra para cada atributo
		1,#máximo multiplicador para cada atributo
	],
	'hard': [
		[0, 7],
		[0, 7],
		[0, 7],
		[0, 7],
		[3, 20],
		true,
		[0, 7],
		3,#máximo boost extra para cada atributo
		1.25,#máximo multiplicador para cada atributo
	],
}

func StartFight(collider):
	var stats = [0, 0, 0, 0, 0, true, 0]
	var builder = ''
	var randBufInt = RANDOM.randi_range(1, 100)
	if randBufInt < 51:
		builder = 'easy'
	elif randBufInt > 50 && randBufInt < 86:
		builder = 'medium'
	elif randBufInt > 85:
		builder = 'hard'
	stats[0] = RANDOM.randi_range(ENEMY_BUILDING[builder][0][0], ENEMY_BUILDING[builder][0][1])
	stats[1] = RANDOM.randi_range(ENEMY_BUILDING[builder][1][0], ENEMY_BUILDING[builder][1][1])
	stats[2] = RANDOM.randi_range(ENEMY_BUILDING[builder][2][0], ENEMY_BUILDING[builder][2][1])
	stats[3] = RANDOM.randi_range(ENEMY_BUILDING[builder][3][0], ENEMY_BUILDING[builder][3][1])
	stats[4] = RANDOM.randi_range(ENEMY_BUILDING[builder][4][0], ENEMY_BUILDING[builder][4][1])
	stats[5] = ENEMY_BUILDING[builder][5]
	stats[6] = RANDOM.randi_range(ENEMY_BUILDING[builder][6][0], ENEMY_BUILDING[builder][6][1])
	for z in range(0, len(stats)-1):
		if z == 5:
			continue
		else:
			stats[z] += RANDOM.randi_range(0, ENEMY_BUILDING[builder][7])
	for z in range(0, len(stats)-1):
		if z == 5:
			continue
		else:
			stats[z] = floor(stats[z]*RANDOM.randf_range(0, ENEMY_BUILDING[builder][8]))
	print(builder, stats)
	var node = preload("res://Fight/Fight.tscn").instance()
	node.collider = collider
	node.ENEMY = {
		'atk_mag': stats[0]*floor(ROOMS_SPAWNED*0.2+1)+floor(SNAKE.LEVEL*0.1),
		'atk_fis': stats[1]*floor(ROOMS_SPAWNED*0.2+1)+floor(SNAKE.LEVEL*0.1),
		'armor': stats[2]*floor(ROOMS_SPAWNED*0.2+1)+floor(SNAKE.LEVEL*0.1),
		'shield': stats[3]*floor(ROOMS_SPAWNED*0.2+1)+floor(SNAKE.LEVEL*0.1),
		'health': stats[4]*floor(ROOMS_SPAWNED*0.2+1)+floor(SNAKE.LEVEL*0.1),
		'coins': stats[5],
		'exp': stats[6]*floor(ROOMS_SPAWNED*0.2+1)+floor(SNAKE.LEVEL*0.1),
	}
	GAME.call_deferred("add_child", node)
	node.global_position = SNAKE.global_position
	SNAKE.control = false

func Step():
	pass

func Spawn(what: String, pos: Vector2, parent = null):
	var node
	
	if what in ['Wall', 'Coin', 'Shop', 'Enemy', 'Objective', 'Exp', 'GoldenApple']:
		node = preload("res://Collider/Collider.tscn").instance()
		var map = {
			'Wall': 0,
			'Coin': 5,
			'Enemy': 6,
			'Shop': 7,
			'GoldenApple': 8,
			'Objective': 9,
			'Exp': 10
		}
		node.type = map[what]
		node.global_position = pos
	
	if what in ['ChooseUpgrade', 'SHOP', 'ChooseGoldenAppleReward']:
		var map = {
			'ChooseUpgrade': "res://Upgrade/ChooseUpgrade.tscn",
			'ChooseGoldenAppleReward': "res://Upgrade/ChooseUpgrade.tscn",
			'SHOP': "res://Shop/Shop.tscn",
		}
		node = load(map[what]).instance()
		node.global_position = pos
		if what == 'ChooseGoldenAppleReward':
			node.TYPE = what
			print(what)
	
	if parent == null:
		GAME.call_deferred("add_child", node)
	else:
		parent.call_deferred("add_child", node)
	
	return node

func _ready():
	RANDOM.randomize()

func set_process_bit(obj, value):
	obj.set_process(value)
	obj.set_physics_process(value)
	obj.set_process_input(value)
	obj.set_process_internal(value)
	obj.set_process_unhandled_input(value)
	obj.set_process_unhandled_key_input(value)

func SpawnRoom(handler):
	var map = {
		'fight': "res://Rooms/Fight/F1.tscn",
	}
	var room = 'fight'#pick the roomType in the actual roomType list
	var node = load(map[room]).instance()
	node.global_position = handler.global_position
	node.node = handler.type
	node.point = handler.global_position
	GAME.call_deferred("add_child", node)
	handler.get_parent().Substituir(handler)
	ACTUAL_PATH.append(handler.get_name())
	handler.queue_free()
































func ReturnValidRandomPosition():
	var Pos = Vector2(stepify(RANDOM.randi_range(-480, 480), 16), stepify(RANDOM.randi_range(-272, 272), 16))
	var buf = []
	for z in ReturnAll():
		for x in z:
			buf.append(x.position)
	while Pos in buf:
		Pos = Vector2(stepify(RANDOM.randi_range(-480, 480), 16), stepify(RANDOM.randi_range(-272, 272), 16))
	return Pos







