extends Node2D

var TYPE = Enums.HABILITIES.WANDERING_FIREWALL

var nearest

var x_walk = 0
var y_walk = 0

var mega = false

func _ready():
	var block_health = Global.PLAYER_INFOS['wandering_health'] - 1 + Global.UPGRADES[Enums.HABILITIES.WANDERING_FIREWALL][2]
	
	if get_child(0).has_mega():
		$Block/Sprite.texture = load(Global.TEXTURE_BY_MEGA_HABILITY[Global.MEGA_BY_HABILITY[TYPE]])
		block_health *= 2
		mega = true
	
	get_child(0).setup_block(block_health, block_health, false)

func die():
	queue_free()

func each_tick():
	find_nearest()
	walk()
	if mega:
		yield(get_tree().create_timer(0.5), "timeout")
		find_nearest()
		walk()

func walk():
	global_position.x += x_walk
	global_position.y += y_walk
	
	x_walk = 0
	y_walk = 0

func find_nearest():
	var all = get_tree().get_nodes_in_group("ENEMY")
	
	if len(all) != 0:
		var distances = []
		
		for z in all:
			distances.append(z.global_position.distance_to(global_position))
		
		var best = all[distances.find(distances.min())]
		
		if best.global_position.x != global_position.x:
			if best.global_position.x > global_position.x:
				x_walk = 16
			
			if best.global_position.x < global_position.x:
				x_walk = -16
		
		if best.global_position.y+16 != global_position.y:
			if best.global_position.y+16 > global_position.y:
				y_walk = 16
			
			if best.global_position.y+16 < global_position.y:
				y_walk = -16
