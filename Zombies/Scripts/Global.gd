extends Node2D


var INFOS = {
	'enemies_spawned': 6,
}

const WEAPON_INFOS = {
	'pistol': {
		'name': 'pistol',
		'shoot_type': 'commom',
		'img': "res://Images/weapons/PISTOL.png",
		'DMG': 1,
		'fire_rate': 0,#se for automática colocar um valor maior que 0
		'bullets': 80,
		'bullet_speed': 1000,
		'pent_bullets': 8,
		'reload': 8,
		'reload_need': 1,#em segundos
		'weight': 0,
	},
	'm4': {
		'name': 'm4',
		'shoot_type': 'commom',
		'img': "res://Images/weapons/M4.png",
		'DMG': 2,
		'fire_rate': 0.1,#se for automática colocar um valor maior que 0
		'bullets': 300,
		'bullet_speed': 1500,
		'pent_bullets': 30,
		'reload': 30,
		'reload_need': 2,#em segundos
		'weight': 5,
	},
	'shotgun': {
		'name': 'shotgun',
		'shoot_type': 'shotgun',
		'img': "res://Images/weapons/SHOTGUN.png",
		'DMG': 1,
		'fire_rate': 0,#se for automática colocar um valor maior que 0
		'bullets': 80,
		'bullet_speed': 1500,
		'pent_bullets': 8,
		'reload': 8,
		'reload_need': 1.5,#em segundos
		'weight': 2.5,
	},
}

const THROWABLE_INFOS = {
	'GRENADE': [20, 0, 0],#[dmg, constant dmg, time]
	'KNIFE': [15, 0, 0],
	'MOLOTOV': [10, 2, 5],
	'SLOW': [0, 0, 5],
	'POISON': [5, 1, 3],
	'': '',
}

const ENEMY_TYPES = {
	'commom': [40, 10, 20, 0],#speed, health, damage, defense
	'healthy': [35, 40, 35, 1],
	'fast': [60, 5, 10, 0],
	'strong': [35, 25, 60, 2],
	'ranger': [30, 15, 30, 1],
	'boss1': [40, 100, 50, 4],
	'boss2': [30, 80, 15, 0],
}

func SPAWN(where, TYPE = null):
	var random = randi()%100+1
	var arra = []
	var answer: String
	var luck = {
		'1-50': 'commom',
		'51-75': 'healthy',
		'76-85': 'fast',
		'86-93': 'strong',
		'94-97': 'ranger',
		'98-99': 'boss1',
		'100-100': 'boss2',
	}
	for z in luck:
		arra.append(z.split('-'))
	for z in arra:
		if random >=  int(z[0]) and random <= int(z[1]):
			answer = luck[z[0]+'-'+z[1]]
			break
	var enemy_generated = ENEMY_SCENE.instance()
	enemy_generated.global_position = where
	if TYPE == null:
		enemy_generated.TYPE = answer
	else:
		enemy_generated.TYPE = TYPE
	get_tree().get_nodes_in_group("MAIN_SCENE")[0].add_child(enemy_generated)
	INFOS['enemies_spawned'] += 1

var ENEMY_SCENE = preload("res://Scenes/ENEMY.tscn")

var levelNavigation: Navigation2D = null
var player = null

func _ready():
	levelNavigation = get_tree().get_nodes_in_group("LevelNavigation")[0]
	player = get_tree().get_nodes_in_group("CHAR")[0]
	add_user_signal("PLAYER_MOVED")
# warning-ignore:return_value_discarded
	connect("PLAYER_MOVED", self, '_on_PLAYER_MOVED_SIGNAL_EMMITED')

func _on_PLAYER_MOVED_SIGNAL_EMMITED():
	for z in get_tree().get_nodes_in_group("ENEMY"):
		z.PATH = levelNavigation.get_simple_path(z.global_position, player.global_position, false)
		z.find_node("ARMA").look_at(player.global_position)
		if z.global_position[0] - player.global_position[0] < 0:
			z.find_node("AnimatedSprite").flip_h = false
		else:
			z.find_node("AnimatedSprite").flip_h = true

