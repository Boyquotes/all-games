extends Node2D

#CONSTS

const SCENES_TYPES = ['DECISION', 'BATTLE', 'SHRINE', 'SHOP', 'WEAPON_SHOP', 'ARMOR_SHOP', 'ACCESSORIES_SHOP', 'CONSUMABLES_SHOP']

const ITEMS = {
	#dmg, mdmg, def, mdef, agi, vit, dxt, ini, str, int, luk
	#actual_health/max_health +-= 2*vit
	#actual_mana/max_mana +-= 2*int
	'sword': [5, 0, 0, 0, 4, 0, 2, 3, 0, 0, 0, 'type in String', 'item name', 'item img'],
	'rusty_sword': [3, 0, 0, 0, 3, 0, 1, 1, 0, 0, 0, 'WEAPON', 'Rusty Sword', ''],
	'': [],
}

#CONSTS

#VARS

var ENEMIES = {
	'template': ['vida_max', 'vida_atual', 'DMG', 'MDMG', 'DEF', 'MDEF', 'INI', ['lista de possíveis ataques'], 'nome do inimigo'],
	'': [],
}

var PLAYER_DATA = {
	'G': 0,
	
	'ACTUAL_ENEMY': null,#lista com as informaçoes tratadas dele
	'ACTUAL_SCENE_TYPE': null,#lista com informações da cena
	'LAST_SCENE_TYPE': null,#lista com informações da cena
	
	'HEAD': null,
	'SHOULDER1': null,
	'SHOULDER2': null,
	'CHEST': null,
	'FOREARM1': null,
	'FOREARM2': null,
	'PANTS': null,
	'WEAPON1': null,
	'WEAPON2': null,
	'FEET1': null,
	'FEET2': null,
	'RING1': null,
	'RING2': null,
	'AMULET1': null,
	'AMULET2': null,
	
	'INVENTORY': [
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'WEAPON', 'GREEN', "res://green.png"],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'WEAPON', 'RED', "res://red.png"],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'WEAPON', 'BLUE', "res://blue.png"],
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		],
	'MAX_INVENTORY_SIZE': 20,
	#ATRIBUTOS
	'DMG': 0,#Dano no inimigo = DMG + STR/2 - INIMIGO['DEF']
	'MDGM': 0,#Dano no inimigo = MDMG + INT/2 - INIMIGO['MDEF']
	
	'DEF': 0,
	'MDEF': 0,
	
	'DXT': 0,
	'AGI': 0,
	
	'VIT': 0,
	
	'INI': 0,
	
	'STR': 0,
	'INT': 0,
	
	'LUK': 0,
	#ATRIBUTOS
	'ACTUAL_HEALTH': 0,
	'MAX_HEALTH': 0,
	'ACTUAL_MANA': 0,
	'MAX_MANA': 0,
	'LEVEL': 1,
	'CLASS': '',
	'NATION': '',
	#blessings list: [['INT', '1'], ['AGI', '-1']]
	'BLESSINGS_LIST': [],
}


#VARS


var MUSIC = true
var VOLUME = 0

func _ready():
	#SAVE()
	#LOAD()
	pass

func SAVE():
	pass

func LOAD():
	var inv_data_file = File.new()
	inv_data_file.open("user://inv_data_file.json", File.READ)
	var inv_data_json = JSON.parse(inv_data_file.get_as_text())
	inv_data_file.close()
	PLAYER_DATA['INVENTORY'] = inv_data_json.result




func ADD_BLESSING(blessing):#[['', '0'], ['', '-1']]
	for z in range(0, len(blessing)):
		PLAYER_DATA[blessing[z][0]] += blessing[z][1]
		PLAYER_DATA['BLESSINGS_LIST'].append(blessing[z][0] + str(blessing[z][1]))
		#SAVE()

func ADD_STATS(type, stats, remove = false):
	if remove == true:
		PLAYER_DATA['DMG'] -= stats[0]
		PLAYER_DATA['MDGM'] -= stats[1]
		PLAYER_DATA['DEF'] -= stats[2]
		PLAYER_DATA['MDEF'] -= stats[3]
		PLAYER_DATA['AGI'] -= stats[4]
		PLAYER_DATA['VIT'] -= stats[5]
		PLAYER_DATA['DXT'] -= stats[6]
		PLAYER_DATA['INI'] -= stats[7]
		PLAYER_DATA['INT'] -= stats[8]
		PLAYER_DATA['LUK'] -= stats[9]
		PLAYER_DATA['ACTUAL_HEALTH'] -= stats[5]*2
		PLAYER_DATA['MAX_HEALTH'] -= stats[5]*2
		PLAYER_DATA['ACTUAL_MANA'] -= stats[8]*2
		PLAYER_DATA['MAX_MANA'] -= stats[8]*2
		PLAYER_DATA[type] = null
	else:
		PLAYER_DATA['DMG'] += stats[0]
		PLAYER_DATA['MDGM'] += stats[1]
		PLAYER_DATA['DEF'] += stats[2]
		PLAYER_DATA['MDEF'] += stats[3]
		PLAYER_DATA['AGI'] += stats[4]
		PLAYER_DATA['VIT'] += stats[5]
		PLAYER_DATA['DXT'] += stats[6]
		PLAYER_DATA['INI'] += stats[7]
		PLAYER_DATA['INT'] += stats[8]
		PLAYER_DATA['LUK'] += stats[9]
		PLAYER_DATA['ACTUAL_HEALTH'] += stats[5]*2
		PLAYER_DATA['MAX_HEALTH'] += stats[5]*2
		PLAYER_DATA['ACTUAL_MANA'] += stats[8]*2
		PLAYER_DATA['MAX_MANA'] += stats[8]*2
		PLAYER_DATA[type] = stats
	#SAVE()

func GENERATE_ENEMY(enemy_name: String):
	var ene = []
	for z in ENEMIES[enemy_name]:
		ene.append(z)
	var fator: float
	match RETURN_RARITY():
		'CO':
			fator = 1
		'UN':
			fator = 1.5
		'RA':
			fator = 2.5
		'EP':
			fator = 4
		'LG':
			fator = 6
	for z in range(0, 7):
		ene[z] *= fator
	PLAYER_DATA['ACTUAL_ENEMY'] = ene
	return ene

#ARITHMETIC FUNCTIONS

func RETURN_DMG(DMG_MDMG: String):
	var value: float
	match DMG_MDMG:
		'DMG':
			value = PLAYER_DATA['DMG']+(PLAYER_DATA['STR']/2)-PLAYER_DATA['ACTUAL_ENEMY'][2]
		'MDMG':
			value = PLAYER_DATA['MDMG']+(PLAYER_DATA['INT']/2)-PLAYER_DATA['ACTUAL_ENEMY'][3]
	return value

func RETURN_RARITY():
	var random = int(randi()%100 + PLAYER_DATA['LUK']/2 + randi()%PLAYER_DATA['LUK'])
	if random <= 50:
		random = 'CO'
	elif random > 50 and random <= 75:
		random = 'UN'
	elif random > 75 and random <= 90:
		random = 'RA'
	elif random > 90 and random <= 98:
		random = 'EP'
	elif random > 98:
		random = 'LG'
	return random

#ARITHMETIC FUNCTIONS

#RARIDADES:
#sorte modifica o random pra mais em que: sorte geral = randi()%100 + sorte/2 + randi()%sorte
#comum - 50(1-50) - CO = padrão de sigla em inglês -> CO = commom, EP = Epic
#incomum - 25(51-75) - UN
#raro - 15(76-90) - RA
#épico - 8(91-98) - EP
#lendário - 2(100) - LG

#história: Não tem

#FUNCIONALIDADES EXPLICADAS

#cada cena terá uma array de ações que podem ser tomadas em relação à ela(que altera a funçaõ dos botões na cena),
#cada decisão tomada terá um dicionário com as devidas chaves que serão raridades que guardarão arrays com as 
#possibilidades do que acontece se tomar aquela decisão.(lembrar de trocar o fundo)
#

#LUTA = player x inimigo(se estiverem em grupo, contam como um só, -
#mas são apresentados como um grupo desses inimigos e são proporcionalmente mais fortes, -
#'atacam ao mesmo tempo' o jogador)

#BLESSINGS = ganho/perda permanente diretamente em atributos

#FUNCIONALIDADES EXPLICADAS

#TEM Q TER

#cenários
#mtos inimigos
#mtos equipamentos que, combinados são mto fortes
#mtas formas de grindar
#masmorras
#áreas de exploração

#TEM Q TER

#scenes types: DECISÃO(pra onde o personagem vai), ['img de fundo', ['possível próxima cena 1', 'possível próxima cena 2', '']]
#BATALHA, ['img de fundo', ['possível próxima cena 1', 'possível próxima cena 2', ''], ['lista de possíveis inimigos']] -
#str do inimigo faz com que na hora da batalha, através da luk do player, o inimigo seja gerado mais forte ou -
#mais fraco - 
#var INIMIGOS = {
#	'inimigo x': [vida_max, vida_atual(= vida max), DMG, MDMG, [lista de possíveis ataques], DEF, MDEF, INI, -
# 'nome do inimigo'], - a animação será pega usando o nome do inimigo.
#}
#LOOT, ['img de fundo', ['possível próxima cena 1', 'possível próxima cena 2', '']]
#SHRINE(local onde se recebe uma BENÇÃO[BLESSINGS),
#SHOP(pra tudo), 
#SMITH, 
#SHOP(só pra armas), 
#SHOP(só pra armaduras), 
#SHOP(só pra acessórios), 
#SHOP(só pra consumíveis)


