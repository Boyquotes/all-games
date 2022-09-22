extends Node2D

const DEMO = true

const LOCATIONS = ['Ocean', 'River', 'Lake', 'Lava Lake', 'Cave Lake', 'Depth Sea']

const ITEMS = {
	'': ['preço de compra', 'preço de venda(se não for possível vender preço de venda = -1)', 'imagem do item', ['atributos do item']],
}

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


func ReturnFishWeight(fishName):
	var weight:float = Fishes.FISHES[fishName][5]
	weight += Fishes.FISHES[fishName][5]*Global.RANDOM.randf_range(0, 0.5)#na sorte
	weight += Fishes.FISHES[fishName][5]*Global.RANDOM.randf_range(0.1, Player.INFOS['Bait'][1]/10)#baseado na Bait
	return weight

func ReturnFishValue(fishName, weight):
	return Fishes.FISHES[fishName][4]+(weight*(Fishes.FISHES[fishName][4]/2))+(Fishes.FISHES[fishName][2]/2)



#MECÂNICAS:
# Barra de stun do peixe:
#	O peixe não puxa a linha ao ser stunado (duração do stun depende de cada peixe, da vara, do anzol e da isca que o jogador está usando)
# Puxar o peixe (caso positivo):
#	O jogador fica com o mouse em cima do peixe e aperta espaço para puxar a linha
# Puxar o peixe (caso negativo):
#	O jogador puxa a linha sem estar com o mouse em cima do peixe e a linha começa a estourar
# Barra de vida da LINHA:
#	O jogador deve se atentar a barra de vida da linha porque ela não se recupera, se a linha estourar o jogador perderá o peixe e deverá comprar e equipar outra linha
#		-incongruencia necessária-> Caso a linha seja danificada durante a pesca e mesmo assim o jogador conseguir percar o peixe a linha não será destruída
# Upgrade de VARA e ANZOL:
#	Será necessário usar a VARA anterior e um pouco de dinheiro para adquirir a próxima (o mesmo funcionamento para o anzol)
# Isca será consumível
#

#TIRA DÚVIDAS:
# O anzol e a vara não quebram, eles apenas ficam mais fortes

#Mecânicas de pesca:
#1 O jogador terá que direcionar a vara na direção oposta em que o peixe está puxando se não a barra de vida da vara começa a descer
#2 acrescenta pontos brilhantes que duram pouco e se o jogador passar o mouse por cima ele consegue aumentar um pouco a barra de stun do peixe
#3 O peixe nadará para a frente e se o jogar tentar puxar o peixe, a linha toma um dano extra, mas terá um círculo amarelo em cima do peixe e se o jogador passar o mouse lá, o peixe toma um pouco de stun
#4 O jogador pode apertar espaço ou clique direito do mouse para puxar bastante o peixe, se o ângulo não corresponder com pelo menos BOM, a linha é danificada, se não o peixe anda um pouco para a frente
#5 Se o jogador puxar a vara durante o rage do peixe e acertar excellent, great ou good, o peixe toma bastante dano de stun e sai do modo rage, MAS se o jogador acertar com BAD, a linha toma bastante dano e o peixe vai um pouco para tras

var CONFIGURATIONS = {
	'music_volume': 0,
	'effects_volume': 0,
}

const ALL_MUSIC_LOOPS = []

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
		'water':
			sounds.stop()
			sounds.set_stream(load(['path 1', 'path 2'][RANDOM.randi_range(0, 4)]))
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
