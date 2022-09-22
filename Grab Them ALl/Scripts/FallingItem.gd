extends Node2D

var INFOS = {
	'fall_type': 'linear',
	'fall_value': 1,
	
	'value': 1,
}

func _process(_delta):
	match INFOS['fall_type']:
		'linear':
			global_position[1] += INFOS['fall_value']
