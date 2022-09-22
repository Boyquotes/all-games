extends Node2D

export(int) var TYPE_X = 0
export(int) var TYPE_Y = 0

var INFOS = {
	'health': 5,
	'max_health': 5,
	
	'shield': 0,
	'max_shield': 0,
	
	'armor': 0,
	'max_armor': 0,
	
	'shield_defense': 0,
	'armor_defense': 0,
	'health_defense': 0,
	
	'speed': 0.25,
	
	'path': [],
	'path_idx': 0,
}

func _enter_tree():
	if TYPE_X < 0:
		TYPE_X = 0
	$Sprite.set_region_rect(Rect2(TYPE_X*16, TYPE_Y*16, 16, 16))
	INFOS['path'] = get_tree().get_nodes_in_group('PATH')[0].get_points()

func _process(_delta):
	global_position += global_position.direction_to(INFOS['path'][INFOS['path_idx']])*INFOS['speed']
	if INFOS['health'] <= 0:
		Global.EarnGears(INFOS['max_health'], INFOS['max_armor'], INFOS['max_shield'])
		queue_free()
	if global_position == INFOS['path'][INFOS['path_idx']]:
		if INFOS['path_idx']+1 <= len(INFOS['path'])-1:
			INFOS['path_idx'] += 1
			$Sprite.look_at(INFOS['path'][INFOS['path_idx']])
		else:
			Global.INFOS['actual_life'] -= ((INFOS['max_health']+INFOS['max_armor']+INFOS['max_shield'])/3)/0.5
			queue_free()









