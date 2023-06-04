extends Node2D

var remaining_ticks

var TYPE = Enums.HABILITIES.PREVENTION

var mega = false

func _ready():
	update_remaining_ticks()
	get_child(0).setup_block(1, 1, false)

func die():
	queue_free()

func update_remaining_ticks():
	remaining_ticks = Global.PLAYER_INFOS['prevention_shoot_ticks_delay'] - (3 * Global.UPGRADES[Enums.HABILITIES.PREVENTION][2])
	
	if mega:
		remaining_ticks /= 2

func shoot():
	remaining_ticks -= 1
	
	if remaining_ticks <= 0:
		update_remaining_ticks()
		
		var valid_enemies_to_shoot = []
		
		for z in get_tree().get_nodes_in_group("ENEMY"):
			if z.global_position.x == global_position.x:
				valid_enemies_to_shoot.append(z)
		
		if len(valid_enemies_to_shoot) > 0:
			var highest_y_pos = valid_enemies_to_shoot[0]
			
			for z in valid_enemies_to_shoot:
				if z.global_position.y > highest_y_pos.global_position.y:
					highest_y_pos = z
			
			var ray = Global.spawn('ray', highest_y_pos.global_position, get_tree().get_nodes_in_group("GAME")[0])
			
			ray.to_position = global_position
			
			highest_y_pos.take_hit(1)
