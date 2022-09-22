extends Node2D

const DEMO = true

var CONFIGURATIONS = {
	'music_volume': 0,
	'effects_volume': 0,
}

const ALL_MUSIC_LOOPS = ["res://Audio/Musics/Loop1.wav", "res://Audio/Musics/Loop2.wav", "res://Audio/Musics/Loop3.wav", "res://Audio/Musics/Loop4.wav"]

var MUSIC_INDEX = 0

var ENEMIES_DISCOVERED = []
var OBJECTIVES_DISCOVERED = []

var PLAYER_POS
var actual_level = 0
var actual_wave = 0

var HIGHEST_LEVEL = 0
var HIGHEST_WAVE = 0

var MAX_LEVEL = 0
#quantos níveis tem no total = MAX_LEVEL + 1

var DIES = 0

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
	actual_level = HIGHEST_LEVEL
	actual_wave = HIGHEST_WAVE

func SALVAR():
	var arquivo = File.new()
	var erro = arquivo.open("res://Save/save.data", File.WRITE)
	var dados = {
		'HIGHEST_LEVEL': HIGHEST_LEVEL,
		'HIGHEST_WAVE': HIGHEST_WAVE,
		}
	if not erro:
		arquivo.store_var(dados)
	arquivo.close()

func CARREGAR():
	var arquivo = File.new()
	var erro = arquivo.open("res://Save/save.data", File.READ)
	if not erro:
		var dados_salvos = arquivo.get_var()
		HIGHEST_LEVEL = dados_salvos['HIGHEST_LEVEL']
		HIGHEST_WAVE = dados_salvos['HIGHEST_WAVE']
		actual_level = HIGHEST_LEVEL
		actual_wave = HIGHEST_WAVE
	arquivo.close()

func set_process_bit(obj, value):
	obj.set_process(value)
	obj.set_physics_process(value)
	obj.set_process_input(value)
	obj.set_process_internal(value)
	obj.set_process_unhandled_input(value)
	obj.set_process_unhandled_key_input(value)
