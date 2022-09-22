extends Node2D

const DEMO = false

const BASE_INTERESTELAR_INFOS = {
	'actual_health': 10,
	'max_health': 10,
	
	'shoot_delay': 0.3,
}

var INTERESTELAR_INFOS = {
	'actual_health': 10,
	'max_health': 10,
	
	'shoot_delay': 0.3,
}

const BASE_INFOS = {
	'allies': 0,
	
	'regen': 0,
	'life_steal': 0,
	
	'spaceship_modules': ["res://Scenes/Spaceship_modules/Arrow.tscn"],
	
	'actual_health': 30,
	'max_health': 30,
	
	'speed': 2.8,#quanto maior a speed, mais rápido
	'defense': 1, #dmg taken = dmg * defense (defense tem que ser um valor menor para proteger mais)
	
	'bullet_type': "res://Scenes/PlayerProjectile.tscn",#tipo = cena para carregar
	'bullet_speed': 300,
	'bullet_dmg': 1,
	'shoot_delay': 0.4,
	'bullet_distance': 3, #in seconds
	'bullet_die': true,
	'bullet_exp': 0.5,
	
	'special_bullet': [null, 0, ''],#[type/bullet type(if none = null), shoot_delay(1segundo = 10: int)],
	'find_special_weapon': 1,#1: int = 2% de chance do inimigo spawnar uma special weapon aleatória
	
	'find_item': 15,
	'find_power_up': 10,
	
	'exp': 0,
	'lvl': 1,
	
	'upgrade_cards': 4,
	'upgrades_list': [],#[[oq upou,  qtas vezes upou], []] Ex:[['shoot_delay', 2]]
	
	'hours': 0,
	'minutes': 0,
	'seconds': 1,
}

var PLAYER_INFOS = {
	'allies': 0,
	
	'regen': 0,
	'life_steal': 0,
	
	'spaceship_modules': ["res://Scenes/Spaceship_modules/Arrow.tscn"],
	
	'actual_health': 30,
	'max_health': 30,
	
	'speed': 2.8,#quanto maior a speed, mais rápido
	'defense': 1, #dmg taken = dmg * defense (defense tem que ser um valor menor para proteger mais)
	
	'bullet_type': "res://Scenes/PlayerProjectile.tscn",#tipo = cena para carregar
	'bullet_speed': 300,
	'bullet_dmg': 1,
	'shoot_delay': 0.4,
	'bullet_distance': 3, #in seconds
	'bullet_die': true,
	'bullet_exp': 0.5,
	
	'special_bullet': [null, 0, ''],#[type/bullet type(if none = null), shoot_delay(1segundo = 10: int)],
	'find_special_weapon': 1,#1: int = 2% de chance do inimigo spawnar uma special weapon aleatória
	
	'find_item': 15,
	'find_power_up': 10,
	
	'exp': 0,
	'lvl': 1,
	
	'upgrade_cards': 4,
	'upgrades_list': [],#[[oq upou,  qtas vezes upou], []] Ex:[['shoot_delay', 2]]
	
	'hours': 0,
	'minutes': 0,
	'seconds': 1,
	
	'upgrade_parts': 0,
}

var SHIP_UPGRADES = {
	#[quantos upgrades fez, valor fixo de melhoria, constante de requisição de melhoria]
	#f(x) = (N)x
	#N = constante -> ex: 7x
	#retorno se nvl 3 = 2*N+1*N
	'max_health': [1, 5, 7, "res://Images/UPGRADES/Icon_max_health.png"],
	'speed': [1, 0.2, 4, "res://Images/UPGRADES/Icon_speed.png"],
	'defense': [1, -0.05, 6, "res://Images/UPGRADES/icon_defense.png"],
	'bullet_speed': [1, 15, 2, "res://Images/UPGRADES/icon_bullet_speed.png"],
	'bullet_dmg': [1, 0.4, 8, "res://Images/UPGRADES/icon_bullet_dmg.png"],
	'shoot_delay': [1, -0.05, 8, "res://Images/UPGRADES/Icon_shoot_delay.png"],
	'allies': [1, 1, 10, "res://Images/UPGRADES/icon_allies.png"],
	'regen': [1, 0.25, 5, "res://Images/UPGRADES/icon_regen.png"],
}


var POSSIBLES_ITEMS = ['upgrade_parts']

var POSSIBLES_POWER_UPS = ['power_up_speed', 'power_up_bullet_dmg', 'power_up_special_bullet', 'power_up_shoot_delay', 'power_up_kill_all_enemies']

var ENEMIES_INFOS = {#[nome do tipo, DMG, shoot delay, bulletspeed, speed, LIFE, projectile dies?, 'scene', 'bullet_scene' ...]
	'Enemy':        ['Enemy', 1, 3.5, 400, 1, 10, true, "res://Scenes/Enemies/Enemy.tscn", "res://Scenes/Enemies_projectiles/EnemyProjectile.tscn"],
	'BIG':          ['BIG', 4, 3, 350, 0.8, 40, true, "res://Scenes/Enemies/BIG.tscn", "res://Scenes/Enemies_projectiles/BIGProjectile.tscn"],
	'Double_shoot': ['Double_shoot', 2, 4, 380, 0.85, 30, true, "res://Scenes/Enemies/Double_shoot.tscn", "res://Scenes/Enemies_projectiles/EnemyProjectile.tscn"],
	'Fast_bullet':  ['Fast_bullet', 2, 4, 525, 0.7, 35, true, "res://Scenes/Enemies/Fast_bullet.tscn", "res://Scenes/Enemies_projectiles/EnemyProjectile.tscn"],
	'High_fire_rate':['High_fire_rate', 1, 1, 390, 0.8, 20, true, "res://Scenes/Enemies/High_fire_rate.tscn", "res://Scenes/Enemies_projectiles/EnemyProjectile.tscn"],
	'Mini':         ['Mini', 2, 2, 380, 2, 15, true, "res://Scenes/Enemies/Mini.tscn", "res://Scenes/Enemies_projectiles/EnemyProjectile.tscn"],
	'Arrow':        ['Arrow', 5, 3, 380, 1, 60, true, "res://Scenes/Enemies/Arrow.tscn", "res://Scenes/Enemies_projectiles/ArrowEnemyProjectile.tscn"],
	'Healthy':        ['Healthy', 4, 2.5, 400, 0.8, 180, true, "res://Scenes/Enemies/Healthy.tscn", "res://Scenes/Enemies_projectiles/EnemyProjectile.tscn"],
	'Wide':        ['Wide', 5, 3, 200, 0.8, 200, true, "res://Scenes/Enemies/Wide.tscn", "res://Scenes/Enemies_projectiles/WideProjectile.tscn"],
}

var ENEMIES_POOL = {
	'Enemy':         [],
	'BIG':           [],
	'Double_shoot':  [],
	'Fast_bullet':   [],
	'High_fire_rate':[],
	'Mini':          [],
	'Arrow':         [],
	'Healthy':       [],
	'Wide':          [],
}


const ENEMIES_SEQUENCE = ['BIG', 'Double_shoot', 'Fast_bullet', 'High_fire_rate', 'Mini', 'Arrow', 'Healthy', 'Wide']
var POSSIBLES_ENEMIES = ['Enemy']



const POSSIBLES_SPECIAL_WEAPONS = [["res://Scenes/Special_bullets/8-DISPERSOR.tscn", 5]]


const UPGRADES = {
	#[estagio1, estagio2, estagio3, '', '', '']
	'bullet_speed': [1.1, 1.2, 1.3, "res://Images/UPGRADES/Bullet_speed.png", '+BULLET SPEED', 'Turret length'],
	'bullet_dmg': [1.2, 1.3, 1.4, "res://Images/UPGRADES/Bullet_dmg.png", '+BULLET DAMAGE', 'Turret gauge'],
	'shoot_delay': [0.85, 0.75, 0.70, "res://Images/UPGRADES/Shoot_delay.png", '+SHOOT SPEED', 'Turret barrel'],
	'max_health': [1.1, 1.25, 1.35, "res://Images/UPGRADES/Max_health.png", '+MAX HEALTH', 'Spaceship plates'],
	'speed': [1.08, 1.16, 1.24, "res://Images/UPGRADES/Speed.png", '+SPEED', 'Spaceship turbines'],
	'defense': [0.9, 0.85, 0.8, "res://Images/UPGRADES/Defense.png", '+DEFENSE', 'Spaceship quality'],
	'bullet_exp': [1.05, 1.1, 1.15, "res://Images/UPGRADES/Bullet_exp.png", '+BULLET EXPERIENCE', 'Bullet Knowledge'],
	
	'regen': [1, 3, 0.1, "res://Images/UPGRADES/Regen.png", '+REGEN PER SEC', 'Repairs'],
	'life_steal': [1, 3, 0.020, "res://Images/UPGRADES/Life_steal.png", '+LIFE STEAL', 'Vampire'],
	'upgrade_cards': [1, 3, 1, "res://Images/UPGRADES/Upgrade_choice.png", '+UPGRADE CHOICE', 'Science'],
	'allies': [1, 3, 1, "res://Images/UPGRADES/Allies.png", '+ALLY', 'Group Up'],
}

var DMG_LABEL_POOL = []
var EXPLOSION_POOL = []

#CRIAR

#Criar sistema de shield igual POE(Path of Exile)

#CRIAR

#INFOS

#As cartas tem um limite que elas podem ser usadas, mas esse limite é muito alto
#upgrade_cards aumenta a quantidade de cartas que aparecem

#Get materials to upgrade the ship

#INFOS

var CONFIGURATIONS = {
	'music_volume': 0,
	'effects_volume': 0,
}

onready var RANDOM = RandomNumberGenerator.new()

var sounds = AudioStreamPlayer.new()
var hits = AudioStreamPlayer.new()

func play_sound(sound):
	match sound:
		'hit':
			hits.stop()
			hits.set_stream(load("res://Mp3/Sounds/Hit.wav"))
			hits.play()
		'shoot':
			sounds.stop()
			sounds.set_stream(load("res://Mp3/Sounds/Shoot.wav"))
			sounds.play()
		'startgame':
			sounds.stop()
			sounds.set_stream(load("res://Mp3/Sounds/StartGame.mp3"))
			sounds.play()

func EXPLODE(pos):
	if len(EXPLOSION_POOL) == 0:
		var node = load("res://Scenes/Explosion.tscn").instance()
		node.global_position = pos
		get_tree().get_nodes_in_group("PLAYER")[0].get_parent().add_child(node)
	else:
		EXPLOSION_POOL[0].visible = true
		EXPLOSION_POOL[0].global_position = pos
		get_tree().get_nodes_in_group("PLAYER")[0].get_parent().add_child(EXPLOSION_POOL[0])
		EXPLOSION_POOL.pop_front()

func _ready():
	RANDOM.randomize()
	sounds.set_bus('Effects')
	hits.set_bus('Effects')
	get_tree().get_root().call_deferred('add_child', sounds)
	get_tree().get_root().call_deferred('add_child', hits)
	

var last_max_health = 30
func _process(_delta):
	if last_max_health != PLAYER_INFOS['max_health']:
		PLAYER_INFOS['actual_health'] += PLAYER_INFOS['max_health']-last_max_health
		last_max_health = PLAYER_INFOS['max_health']

func ADD_ENEMY(type = null, stronger = false):
	RANDOM.randomize()
	var ene
	var node
	if stronger == true:
		var value = len(Global.POSSIBLES_ENEMIES)-1
		if value >= len(Global.ENEMIES_SEQUENCE):
			value = len(Global.ENEMIES_SEQUENCE)-1
		ene = Global.ENEMIES_SEQUENCE[value]
	else:
		if type == null:
			ene = Global.POSSIBLES_ENEMIES[RANDOM.randi_range(0, len(Global.POSSIBLES_ENEMIES)-1)]
		else:
			ene = type
	if len(ENEMIES_POOL[ene]) == 0:
		node = load(Global.ENEMIES_INFOS[ene][7]).instance()
		node.TYPE = Global.ENEMIES_INFOS[ene]
		get_tree().get_nodes_in_group("PLAYER")[0].get_parent().call_deferred('add_child', node)
	else:
		node = ENEMIES_POOL[ene][0]
		node.TYPE = ENEMIES_INFOS[node.TYPE[0]]
		ENEMIES_POOL[ene].pop_front()
		node.run()
	Global.RANDOM.randomize()
	var x = Global.RANDOM.randi_range(0, 2)
	Global.RANDOM.randomize()
	var y = Global.RANDOM.randi_range(0, 2)
	if x == 1:
		x = -1
	else:
		x = 1
	if y == 1:
		y = -1
	else:
		y = 1
	Global.RANDOM.randomize()
	node.global_position = Vector2((Global.RANDOM.randf_range(0, 1)*500+300)*x+get_tree().get_nodes_in_group("PLAYER")[0].global_position[1], (Global.RANDOM.randf_range(0, 1)*500+300)*y+get_tree().get_nodes_in_group("PLAYER")[0].global_position[1])
	

func ADD_DMG_LABEL(pos, value, player = false):
	if len(DMG_LABEL_POOL) == 0:
		var node = load("res://Scenes/Modules/Hit_info.tscn").instance()
		node.rect_global_position = pos
		node.text = "%.1f" % value
		if player == true:
			node.set_modulate(Color(0, 0, 1))
		else:
			node.set_modulate(Color(1, 1, 1))
		get_tree().get_nodes_in_group("PLAYER")[0].get_parent().add_child(node)
	else:
		DMG_LABEL_POOL[0].rect_global_position = pos
		DMG_LABEL_POOL[0].text = "%.1f" % value
		if player == true:
			DMG_LABEL_POOL[0].set_modulate(Color(0, 0, 1))
		else:
			DMG_LABEL_POOL[0].set_modulate(Color(1, 1, 1))
		get_tree().get_nodes_in_group("PLAYER")[0].get_parent().add_child(DMG_LABEL_POOL[0])
		DMG_LABEL_POOL.pop_front()

func ADD_BULLET(type: String, infos: Array):
	#infos = [global_position, rotation_degrees, DMG, DIE, ROTATION, SPEED, TYPE]
	#if len(BULLETS_POOL[type]) == 0:
	var bullet_instance = load(type).instance()
	bullet_instance.position = infos[0]
	bullet_instance.rotation_degrees = infos[1]
	bullet_instance.DMG = infos[2]
	bullet_instance.DIE = infos[3]
	bullet_instance.TYPE = infos[6]
	bullet_instance.set_linear_velocity(Vector2(infos[5], 0).rotated(infos[4]))
	#bullet_instance.apply_impulse(Vector2(), Vector2(infos[5], 0).rotated(infos[4]))
	get_tree().get_root().call_deferred('add_child', bullet_instance)
	#else:
		#BULLETS_POOL[type][0].position = infos[0]
		#BULLETS_POOL[type][0].rotation_degrees = infos[1]
		#BULLETS_POOL[type][0].DMG = infos[2]
		#BULLETS_POOL[type][0].DIE = infos[3]
		#BULLETS_POOL[type][0].ROTATION = infos[4]
		#BULLETS_POOL[type][0].SPEED = infos[5]
		#BULLETS_POOL[type][0].TYPE = infos[6]
		#BULLETS_POOL[type][0].set_linear_velocity(Vector2(infos[5], 0).rotated(infos[4]))
		#BULLETS_POOL[type][0].apply_impulse(Vector2(), Vector2(infos[5], 0).rotated(infos[4]))
		#get_tree().get_nodes_in_group("PLAYER")[0].get_parent().call_deferred('add_child', BULLETS_POOL[type][0])
		#BULLETS_POOL[type].pop_front()

func SET_POWER_UP(type):#duration in seconds
	match type:
		'power_up_speed':#green
			Global.PLAYER_INFOS['speed'] *= 2
			yield(get_tree().create_timer(10), "timeout")
			Global.PLAYER_INFOS['speed'] /= 2
		'power_up_bullet_dmg':#red
			Global.PLAYER_INFOS['bullet_dmg'] *= 2
			yield(get_tree().create_timer(10), "timeout")
			Global.PLAYER_INFOS['bullet_dmg'] /= 2
		'power_up_special_bullet':#purple
			Global.PLAYER_INFOS['bullet_type'] = "res://Scenes/Special_bullets/8-DISPERSOR.tscn"
			yield(get_tree().create_timer(10), "timeout")
			Global.PLAYER_INFOS['bullet_type'] = "res://Scenes/PlayerProjectile.tscn"
		'power_up_shoot_delay':#orange
			Global.PLAYER_INFOS['shoot_delay'] /= 2
			yield(get_tree().create_timer(10), "timeout")
			Global.PLAYER_INFOS['shoot_delay'] *= 2
		'power_up_kill_all_enemies':#white
			#PLAY AN EXPLOSION ANIMATION
			for z in get_tree().get_nodes_in_group('ENEMY'):
				if z.global_position.distance_to(get_tree().get_nodes_in_group("PLAYER")[0].global_position) <= 500 and z.visible == true:
					z.queue_free()

func SALVAR():
	var arquivo = File.new()
	var erro = arquivo.open("res://Save/save.data", File.WRITE)
	var dados = {
		'PLAYER_INFOS': PLAYER_INFOS,
		'SHIP_UPGRADES': SHIP_UPGRADES,
		'CONFIGURATIONS': CONFIGURATIONS,
		}
	if not erro:
		arquivo.store_var(dados)
	arquivo.close()

func CARREGAR():
	var arquivo = File.new()
	var erro = arquivo.open("res://Save/save.data", File.READ)
	if not erro:
		var dados_salvos = arquivo.get_var()
		PLAYER_INFOS = dados_salvos['PLAYER_INFOS']
		SHIP_UPGRADES = dados_salvos['SHIP_UPGRADES']
		CONFIGURATIONS = dados_salvos['CONFIGURATIONS']
	arquivo.close()

func set_process_bit(obj, value):
	obj.set_process(value)
	obj.set_physics_process(value)
	obj.set_process_input(value)
	obj.set_process_internal(value)
	obj.set_process_unhandled_input(value)
	obj.set_process_unhandled_key_input(value)
