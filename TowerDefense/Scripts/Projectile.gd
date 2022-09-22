extends Area2D

var INFOS = {
	'health_dmg': 0,
	'health_trepass': 0,
	'armor_dmg': 0,
	'armor_trepass': 0,
	'shield_dmg': 0,
	'shield_trepass': 0,
	
	'direction': Vector2.ZERO,
	'speed': 5,
	'projectile_health': 1,
}

func _process(_delta):
	global_position += INFOS['direction']*INFOS['speed']

func _on_Projectile_area_entered(area):
	area = area.get_parent()
	if area.is_in_group("ENEMY"):
		if INFOS['projectile_health'] > 0:
			Global.CalculateDamage(INFOS['health_dmg'], INFOS['health_trepass'], INFOS['armor_dmg'], INFOS['armor_trepass'], INFOS['shield_dmg'], INFOS['shield_trepass'], area)
		INFOS['projectile_health'] -= 1
		if INFOS['projectile_health'] <= 0:
			queue_free()
