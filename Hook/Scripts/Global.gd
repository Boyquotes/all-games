extends Node2D

var PLAYER_INFOS = {
	'actual_health': 5,
	'max_health': 5,
	
	'bullet_type': "res://Scenes/PlayerProjectile.tscn",#tipo = cena para carregar
	'bullet_speed': 1250,
	'bullet_dmg': 1,
	'shoot_delay': 0.4,
	'bullet_die': true,
	
	'weapons': ['pistol'],# 'rifle', 'shotgun'],
}


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

func _ready():
	RANDOM.randomize()
	sounds.set_bus('Effects')
	hits.set_bus('Effects')
	get_tree().get_root().call_deferred('add_child', sounds)
	get_tree().get_root().call_deferred('add_child', hits)

func ADD_BULLET(type: String, infos: Array):
	#infos = [global_position, rotation_degrees, DMG, DIE, ROTATION, SPEED, TYPE]
	#if len(BULLETS_POOL[type]) == 0:
	var bullet_instance = load(type).instance()
	bullet_instance.position = infos[0]
	bullet_instance.rotation_degrees = infos[1]
	bullet_instance.DMG = infos[2]
	bullet_instance.set_linear_velocity(Vector2(infos[5], 0).rotated(infos[4]))
	#bullet_instance.apply_impulse(Vector2(), Vector2(infos[5], 0).rotated(infos[4]))
	get_tree().get_nodes_in_group("PLAYER")[0].get_parent().call_deferred('add_child', bullet_instance)
