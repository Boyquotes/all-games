extends Node2D

#CONSTS AREA
const TEXTURES = {#texture path to use on load()
	'basic_tower_icon': "res://Images/Tower/Tower_icons/basic.png",
	'flat_tower_icon': "res://Images/Tower/Tower_icons/flat.png",
	'dispersor_tower_icon': "res://Images/Tower/Tower_icons/dispersor.png",
	
	'basic_tower_gun': "res://Images/Tower/Gun/Basic.png",
	'duo_basic_tower_gun': "res://Images/Tower/Gun/Duo.png",
	'trio_basic_tower_gun': "res://Images/Tower/Gun/Trio.png",
	
	'flat_tower_gun': "res://Images/Tower/Gun/Flat.png",
	'duo_flat_tower_gun': "res://Images/Tower/Gun/DuoFlat.png",
	'trio_flat_tower_gun': "res://Images/Tower/Gun/TripleFlat.png",
	
	'dispersor_tower_gun': "res://Images/Tower/Gun/Dispersor.png",
	'duo_dispersor_tower_gun': "res://Images/Tower/Gun/DuoDispersor.png",
	'trio_dispersor_tower_gun': "res://Images/Tower/Gun/TripleDispersor.png",
	
	'': '',
}

const ALL_BASIC_TOWERS_TYPES = ['basic', 'dispersor', 'flat']

const MAX_ENEMY_X_TYPE = 9
const MAX_ENEMY_Y_TYPE = 6

#CONSTS AREA

var INFOS = {
	
	'actual_life': 10,
	'max_life': 10,
	'gears': 50,
	
	'kills': 0,
	'boost_gears_per_kill': 0.1,
	'gears_per_kill': 0.25,
	
	'actual_round': 1,
	'boost_gears_per_round': 0.1,
	'gears_per_round': 1,
}

var UPGRADES = {
	'max_life': [],
	'gears': [],
	'boost_gears_per_kill': [],
	'gears_per_kill': [],
	'boost_gears_per_round': [],
	'gears_per_round': [],
}


var CONFIGURATIONS = {
	'autopass': true,
}

var RAND = RandomNumberGenerator.new()

func _ready():
	RAND.randomize()












func CalculateDamage(health_dmg, armor_dmg, shield_dmg, health_trepass, shield_trepass, armor_trepass, enemy) -> void:
	var calculated_health_dmg = (health_dmg-abs(enemy.INFOS['health_defense']-health_trepass))
	var calculated_armor_dmg = (armor_dmg-abs(enemy.INFOS['armor_defense']-armor_trepass))
	var calculated_shield_dmg = (shield_dmg-abs(enemy.INFOS['shield_defense']-shield_trepass))
	if calculated_health_dmg > 0:
		enemy.INFOS['health'] -= calculated_health_dmg
	if calculated_armor_dmg > 0:
		enemy.INFOS['armor'] -= calculated_armor_dmg
	if calculated_shield_dmg > 0:
		enemy.INFOS['shield'] -= calculated_shield_dmg

func EarnGears(health, armor, shield) -> void:
	var calculated_gears = int((health*0.5)+(armor*0.5)+(shield*0.5)+(INFOS['boost_gears_per_kill']*INFOS['kills'])+INFOS['gears_per_kill'])
	if calculated_gears >= 1:
		INFOS['gears'] += calculated_gears
