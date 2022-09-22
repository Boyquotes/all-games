extends Node2D

#IMPORTANTE

#SALVAR A CADA (1) SEGUNDO

#MULTIPLICADOR DE -50% NO PREÇO DE VENDA PARA PLANTAS DENTRO DA ESTAÇÃO DE PLANTIO
#MULTIPLICADOR DE +50% NO PREÇO DE VENDA PARA PLANTAS FORA DA ESTAÇÃO DE PLANTIO

#IMPORTANTE


#NÍVEIS = estrelas:
#0 - não tem
#plantas: min 1, max 5
#ferramentas: min 0 ou 1, max 5
#instalações: min 0 ou 1, max 5
#cada nivel de que passa aumenta 1 zero no custo padrão de upgrade da ferramenta
#transição básica de níveis: branco < verde < azul < roxo < laranja

const ALL_PLANTS_LIST = ['cenoura', 'milho', 'soja', 'trigo']#abobora, 
const ALL_ANIMAL_PRODUCTS_LIST = ['leite_vaca', 'carne_boi', 'leite_cabra', 'ovo', 'la', 'carne_porco']
const ESTACAO = {
	'Spring': ['cenoura', 'milho'],#lista de todas as plantas favoráveis enssa estação
	'Summer': ['soja', 'trigo'],
	'Autumn': [],
	'Winter': [],#winter deve ficar vazio, só q não pq vão ter plantas de inverno tmb, mas só lá pra frente
}


var SHOP = [['semente_de_cenoura', 1],['semente_de_trigo', 1],['semente_de_milho', 1]]

var LANGUAGE = 'pt-br'

const TEXT = {
	'pt-br': {
		'descricoes': {
			'semente_de_cenoura': 'descrição',
			'semente_de_trigo': 'descrição',
			'semente_de_soja': 'descrição',
			'semente_de_milho': 'descrição',
			'cenoura': 'descrição',
			'trigo': 'descrição',
			'soja': 'descrição',
			'milho': 'descrição',
			'porco': 'descrição',
			'boi': 'descrição',
			'vaca': 'descrição',
			'cabra': 'descrição',
			'ovelha': 'descrição',
			'galinha': 'descrição',
			'carne-porco': '',
			'carne-boi': '',
			'leite-vaca': '',
			'leite-cabra': '',
			'la': '',
			'ovo': '',
			'': '',
		},
		'nomes': {
			'semente_de_cenoura': 'Sementes de cenoura',
			'semente_de_trigo': 'Sementes de trigo',
			'semente_de_soja': 'Sementes de soja',
			'semente_de_milho': 'Sementes de milho',
			'cenoura': 'Cenoura',
			'trigo': 'Trigo',
			'soja': 'Soja',
			'milho': 'Milho',
			'porco': 'Porco',
			'boi': 'Boi',
			'vaca': 'Vaca',
			'cabra': 'Cabra',
			'ovelha': 'Ovelha',
			'galinha': 'Galinha',
			'': '',
		},
		'workers': {
			#nome e descrição dos workers
			'0': ['', ''],
			'1': ['', ''],
			#nome e descrição dos workers
		},
		'Você não possui nenhuma semente': 'Você não possui nenhuma semente',
		'Você não tem nenhum item': 'Você não tem nenhum item',
		'Planta': 'Planta',
		'Estação': 'Estação',
		'Valor': 'Valor',
		'Item': 'Item',
		'Nível': 'Nível',
		'Melhorar': 'Melhorar',
		'Custo': 'Custo',
		'Comprar': 'Comprar',
		'Descrição': 'Descrição',
		'Contratar': 'Contratar',
		'': '',
		'texto em pt br': 'texto em pt br',
	},
	'eng': {
		'descricoes': {
			'semente_de_cenoura': '',
			'semente_de_trigo': '',
			'semente_de_soja': '',
			'semente_de_milho': '',
			'cenoura': '',
			'trigo': '',
			'soja': '',
			'milho': '',
			'porco': '',
			'boi': '',
			'vaca': '',
			'cabra': '',
			'ovelha': '',
			'galinha': '',
			'': '',
		},
		'nomes': {
			'semente_de_cenoura': 'Carrot seeds',
			'semente_de_trigo': 'Wheat seeds',
			'semente_de_soja': 'Soy seeds',
			'semente_de_milho': 'Corn seeds',
			'cenoura': 'Carrot',
			'trigo': 'Wheat',
			'soja': 'Soy',
			'milho': 'Corn',
			'porco': 'Pig',
			'boi': 'Ox',
			'vaca': 'Cow',
			'cabra': 'Goat',
			'ovelha': 'Sheep',
			'galinha': 'Chicken',
			'': '',
		},
		'workers': {
			#nome e descrição dos workers
			'0': ['nome do worker', 'descrição do worker'],
			'1': ['', ''],
			#nome e descrição dos workers
		},
		'Você não possui nenhuma semente': "You don't have any seed",
		'Você não tem nenhum item': "You don't have any item",
		'Planta': 'Plant',
		'Estação': 'Season',
		'Valor': 'Value',
		'Item': 'Item',
		'Nível': 'Level',
		'Melhorar': 'Upgrade',
		'Custo': 'Cost',
		'Comprar': 'Buy',
		'Descrição': 'Description',
		'Contratar': 'Contratar',
		'': '',
		'texto em pt br': 'texto em ingles',
	},
}


#	'-1': {
#		'imagem do worker': '',#path da png
#		'intervalo que ele faz entre uma tarefa e outra (em segundos)': 0,
#		'força (quanto que ele hitta na tarefa)': 0,
#		'taxa de contratacao (quanto ele custa para ser adicionado)': 0,
#		'salario (quanto gasta para fazer cada ação)': 0,
#	},

const WORKERS = {
	'0': {
		'img': "res://Images/WORKERS/0.png",
		'interval': 5,
		'hit': 4,
		'tax': 50,
		'pay': 2, 
		#não custa nada demitir o worker
		#workers não tem nenhuma aleatoriedade, a aleatoriedade vêm da aparição deles a aba de contratar um worker
		#não é possível ter 2 workers iguais em terrenos diferentes, eles não se multiplicam
		#LEMBRAR DE FAZER UMA DESCRIÇÃO PARA CADA WORKER
	},
	'1': {
		'img': "res://Images/WORKERS/1.png",
		'interval': 5,
		'hit': 4,
		'tax': 50,
		'pay': 2, 
	},
	'2': {
		'img': "res://Images/WORKERS/1.png",
		'interval': 5,
		'hit': 4,
		'tax': 50,
		'pay': 2, 
	},
}

#upar -> cliques == 10000 * NIVEL


#adicionar uma forma de reorganizar as scenes_list - futuro distante (fazer dnq o jogo estiver 80% pronto, 100% estável)
var INVENTORY = {
	'actual_scene': 0,
	'scenes_list': ['terreno_padrao'],
	'scenes_info': [['', 1, 1, 0, [], 200, 200, 0, 0, 'limpar', true]],#lista com todas as informações relevantes para o msm index do scenes_list
	'multiplicador': 15,
	'money': 100,
	'diamonds': 0,
	'nivel': 1,
	'total_cliques': 0,
	'cliques': 0,#vai ser voltado a 0 e upar de nivel
	'estacao_atual': 'Spring',#Spring, Summer, Autumn, Winter
	'estacao_time_remaining': 900,
	#shop
	'maximum_shop_items': 3,
	'refresh_price': 10,#aumenta de 1 em 1
	'shop_possibilities': ['semente_de_soja','semente_de_cenoura','semente_de_milho','semente_de_trigo'],#lista com os possíveis itens do shop para sementes
	#shop
	#workers
	'maximum_workers_shop': 3,
	'workers_contratados': [],#[id do worker = int]
	'refresh_worker': 10,#aumenta de 1 em 1
	#workers
	
	'nivel_rastelo': 1,#valor base = 10
	'nivel_enxada': 1,#valor base = 15
	'nivel_regador': 1,#valor base = 20
	'nivel_relogio': 1,#valor base = 25
	'nivel_luvas': 1,#valor base = 30 (luva pra colher a plantação)
	
	'cenoura': 0,
	'trigo': 0,
	'milho': 0,
	'soja': 0,
	
	'semente_de_cenoura': [],
	'semente_de_trigo': [],
	'semente_de_milho': [],
	'semente_de_soja': [],
	
	'porco': 0,
	'vaca': 0,
	'boi': 0,
	'cabra': 0,
	'galinha': 0,
	'ovelha': 0,
	
	'leite_vaca': 0,#uni=Litro
	'carne_boi': 0,#uni=Kg
	'leite_cabra': 0,#uni=Litro
	'ovo': 0,#uni
	'la': 0,#uni
	'carne_porco': 0,#uni=Kg
	'': 0,
}

const TEXTURES = {
	
	'maximum_workers_shop': "res://Images/FERRAMENTAS/RASTELO.png",
	'maximum_shop_items': "res://Images/FERRAMENTAS/RASTELO.png",
	'nivel_rastelo': "res://Images/FERRAMENTAS/RASTELO.png",
	'nivel_enxada': "res://Images/FERRAMENTAS/ENXADA.png",
	'nivel_regador': "res://Images/FERRAMENTAS/REGADOR.png",
	'nivel_relogio': "res://Images/FERRAMENTAS/RELOGIO.png",
	'nivel_luvas': "res://Images/FERRAMENTAS/LUVAS.png",
	
	'Spring': "res://Images/SPRING.png",
	'Summer': "res://Images/SUMMER.png",
	'Autumn': "res://Images/AUTUMN.png",
	'Winter': "res://Images/WINTER.png",
	
	'semente_de_cenoura': "res://Images/CROPS/SEED-CENOURA.png",#string do path
	'semente_de_trigo': "res://Images/CROPS/SEED-TRIGO.png",
	'semente_de_soja': "res://Images/CROPS/SEED-SOJA.png",
	'semente_de_milho': "res://Images/CROPS/SEED-MILHO.png",
	
	'cenoura': "res://Images/CROPS/CENOURA.png",
	'trigo': "res://Images/CROPS/TRIGO.png",
	'soja': "res://Images/CROPS/SOJA.png",
	'milho': "res://Images/CROPS/MILHO.png",
	
	'porco': "res://Images/ICONES_DE_JOGABILIDADE/PORCO-ICON.png",
	'boi': "res://Images/ICONES_DE_JOGABILIDADE/BOI-ICON.png",
	
	'vaca': "res://Images/ICONES_DE_JOGABILIDADE/VACA-ICON.png",
	'cabra': "res://Images/ICONES_DE_JOGABILIDADE/CABRA-ICON.png",
	'ovelha': "res://Images/ICONES_DE_JOGABILIDADE/OVELHA-ICON.png",
	'galinha': "res://Images/ICONES_DE_JOGABILIDADE/GALINHA-ICON.png",
	
	'ovo': "res://Images/ANIMAL_PRODUCTS/OVO.png",
	'la': "res://Images/ANIMAL_PRODUCTS/LA.png",
	'leite_vaca': "res://Images/ANIMAL_PRODUCTS/LEITE-VACA.png",
	'leite_cabra': "res://Images/ANIMAL_PRODUCTS/LEITE-CABRA.png",
	'carne_boi': "res://Images/ANIMAL_PRODUCTS/CARNE-BOI.png",
	'carne_porco': "res://Images/ANIMAL_PRODUCTS/CARNE-PORCO.png",
	'': '',
}

const BASE_PRICES = {
	
	'maximum_shop_items': 1000,
	'nivel_rastelo': 1500,
	'nivel_enxada': 1500,
	'nivel_regador': 1500,
	'nivel_relogio': 1500,
	'nivel_luvas': 1500,
	
	'semente_de_cenoura-1': 10,
	'semente_de_trigo-1': 10,
	'semente_de_milho-1': 10,
	'semente_de_soja-1': 10,
	
	'semente_de_cenoura-2': 50,
	'semente_de_trigo-2': 50,
	'semente_de_milho-2': 50,
	'semente_de_soja-2': 50,
	
	'semente_de_cenoura-3': 250,
	'semente_de_trigo-3': 250,
	'semente_de_milho-3': 250,
	'semente_de_soja-3': 250,
	
	'semente_de_cenoura-4': 1250,
	'semente_de_trigo-4': 1250,
	'semente_de_milho-4': 1250,
	'semente_de_soja-4': 1250,
	
	'semente_de_cenoura-5': 6250,
	'semente_de_trigo-5': 6250,
	'semente_de_milho-5': 6250,
	'semente_de_soja-5': 6250,
	
	'cenoura': 5,
	'trigo': 5,
	'soja': 5,
	'milho': 5,
	'porco': 20,
	'boi': 20,
	'vaca': 10,
	'cabra': 10,
	'ovelha': 10,
	'galinha': 10,
	'': '',
}

var game_save_class: Script = load("res://Scripts/Game_save_class.gd")

var MUSIC = true
var VOLUME = 0

var USERS_FAVORITE_DRINKS = []

#func _ready():
#	SAVE()
#	LOAD()
#	SET_BANNER()

func _physics_process(_delta):
	var _a = randi()%100
	if INVENTORY['cliques'] == (INVENTORY['nivel'] * 10000 + (INVENTORY['nivel']-1*5000)):
		pass

func SET_BANNER():
	if MobileAds.get_is_initialized():
		var item_text : String = 'FULL_BANNER'
		MobileAds.config.banner.size = item_text
		if MobileAds.get_is_banner_loaded():
			MobileAds.load_banner()

func SAVE():
	var new_save = game_save_class.new()
	new_save.FAVORITE_DRINKS = USERS_FAVORITE_DRINKS
	new_save.MUSIC = MUSIC
	new_save.VOLUME = VOLUME
	
# warning-ignore:return_value_discarded
	ResourceSaver.save("user://game_save.tres", new_save)

func LOAD():
	var dir = Directory.new()
	if not dir.file_exists("user://game_save.tres"):
		return false
	
	var saved_game = load("user://game_save.tres")
	
	for z in saved_game.FAVORITE_DRINKS:
		USERS_FAVORITE_DRINKS.append(z)
	
	MUSIC = saved_game.MUSIC
	VOLUME = saved_game.VOLUME
	AudioServer.set_bus_volume_db(1, VOLUME)
	
	return true
