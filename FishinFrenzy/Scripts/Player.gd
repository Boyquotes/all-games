extends Node2D

var INFOS = {#essas são as coisas que o player vai estar usando durante a pesca
	'Line': ['line_name', 'level', 'line_resistance_boost'],
	'Rod': ['rod_name', 'level', 'specific_region_boost'],
	'Hook': ['hook_name', 1, 'pull_boost'],
	'Bait': ['bait_name', 'level', 'specific_fish_attraction'],
}

var INVENTORY = {
	'lines': [['line_name', 'quantity', 'line_resistance_boost', 'level']],#só perde se o peixe estourar a linha
	'rods': [['rod_name', 'quantity=sempre 1', 'specific_region_boost', 'level']],#não perde
	'hooks': [['hook_name', 'quantity', 'pull_boost', 'level']],#só perde se o peixe estourar a linha
	'baits': [['bait_name', 'quantity', 'specific_fish_attraction', 'level']],#sempre gasta 1 bait
}

func _ready():
	Global.set_process_bit(self, false)

