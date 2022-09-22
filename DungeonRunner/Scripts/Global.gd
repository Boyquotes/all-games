extends Node2D

func ReturnFactorial(num):
	if num == 1:
		return 1;
	else:
		return num*ReturnFactorial(num-1);

class ExampleClass:
	
	var INFOS = {
		'abacaxi': 'abacaxi',
	}
	
	func setInfo(info, value) -> void:
		var error = true
		for z in INFOS:
			if z == info:
				error = false
				break
		if error == true:
			printerr('setInfo failed! info: '+str(info))
			breakpoint
		else:
			INFOS[info] = value
	
	func getInfo(info):
		var error = true
		for z in INFOS:
			if z == info:
				error = false
				break
		if error == true:
			printerr('getInfo failed! info: '+str(info))
			breakpoint
		else:
			return INFOS[info]

var CONFIGURATIONS = {
	'music_volume': 0,
}

const ALL_MUSIC_LOOPS = []

var MUSIC_INDEX = 0

onready var RANDOM = RandomNumberGenerator.new()

var sounds = AudioStreamPlayer.new()

func play_sound(sound):
	match sound:
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
