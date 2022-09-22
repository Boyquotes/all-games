extends Node2D

const DEMO = true

var CONFIGURATIONS = {
	'music_volume': 0,
	'effects_volume': 0,
}

var actual_max_length = 10
var LENGTHS = {
	'2': [],
	'3': [],
	'4': [],
	'5': [],
	'6': [],
	'7': [],
	'8': [],
	'9': [],
	'10': [],
	'11': [],
	'12': [],
	'13': [],
	'14': [],
}

func RETURN_TEXT():
	var rand_index = Global.RANDOM.randi_range(2, Global.actual_max_length)
	var randu = Global.RANDOM.randi_range(0, len(Global.LENGTHS[str(rand_index)])-1)
	return Global.LENGTHS[str(rand_index)][randu]


const ALL_MUSIC_LOOPS = ["res://Musics/CyberLoop1.wav"]

var MUSIC_INDEX = 0

var HIGHEST_STREAK = 0
var HIGHEST_SCORE = 0
var HIGHEST_WPM = 0

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
	#sounds.set_bus('Effects')
	#hits.set_bus('Effects')
	#get_tree().get_root().call_deferred('add_child', sounds)
	#get_tree().get_root().call_deferred('add_child', hits)
	
	for z in Words.WORDS:
		LENGTHS[str(len(z))].append(z)
	#var total = 0
	#for z in LENGTHS:
	#	print(len(LENGTHS[z]))
	#	total += len(LENGTHS[z])
	#print(total)

func SALVAR():
	var arquivo = File.new()
	var erro = arquivo.open("res://Save/save.data", File.WRITE)
	var dados = {
		'HIGHEST_LEVEL': 1,
		'HIGHEST_WAVE': 1,
		}
	if not erro:
		arquivo.store_var(dados)
	arquivo.close()

func CARREGAR():
	var arquivo = File.new()
	var erro = arquivo.open("res://Save/save.data", File.READ)
	if not erro:
		var _dados_salvos = arquivo.get_var()
	arquivo.close()

func set_process_bit(obj, value):
	obj.set_process(value)
	obj.set_physics_process(value)
	obj.set_process_input(value)
	obj.set_process_internal(value)
	obj.set_process_unhandled_input(value)
	obj.set_process_unhandled_key_input(value)
