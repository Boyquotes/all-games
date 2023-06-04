extends Node2D

const BLOCKS_GROUP = 'BLOCK'

export(Enums.ENEMIES) var TYPE

var health = 1

var int_buffer = 0
var bool_buffer = false

var next_pos = null

onready var GAME = get_tree().get_nodes_in_group("GAME")[0]

func _ready():
	health = Dicts.HEALTH_BY_ENEMY[TYPE]
	
	Global.show_tutorial(Dicts.NAME_BY_ENEMY[TYPE])

var change_int_buffer = false
var change_bool_buffer = false

func return_random_side():
	change_int_buffer = true
	change_bool_buffer = true
	
	if bool_buffer == false:
		return Vector2(0, 16)
	else:
		int_buffer = Global.RANDOM.randi_range(0, 1)
		
		return Vector2(-16 + (int_buffer * 32), 0)

func move_to_random_side():
	var side = return_random_side()
	
	move(side.x, side.y)

func return_random_diagonal():
	change_int_buffer = true
	return Vector2(-16 + (int_buffer * 32), 16)

func move_to_random_diagonal():
	var diagonal = return_random_diagonal()
	move(diagonal.x, diagonal.y)

func add_next_pos_preview():
	match TYPE:
		Enums.ENEMIES.RANSOMWARE:
			next_pos = return_random_side()
			
		Enums.ENEMIES.SPOOFING:
			match Global.RANDOM.randi_range(1, 3):
				1:
					next_pos = Vector2(0, 16)
				2:
					next_pos = return_random_diagonal()
				3:
					next_pos = return_random_side()
	
	$Arrow.visible = true
	$Arrow.look_at(global_position + next_pos)

func choose_movement_by_type():
	match TYPE:
		Enums.ENEMIES.BRUTUS:
			move(0, 16)
			
		Enums.ENEMIES.SQL:
			move(0, 16)
			
		Enums.ENEMIES.PHISHING:
			move_to_random_diagonal()
			$Sprite.set_flip_h(!$Sprite.is_flipped_h())
			
		Enums.ENEMIES.RANSOMWARE:
			if next_pos == null:
				move_to_random_side()
			else:
				move(next_pos.x, next_pos.y)
			add_next_pos_preview()
			
		Enums.ENEMIES.SPOOFING:
			if next_pos == null:
				match Global.RANDOM.randi_range(1, 3):
					1:
						move(0, 16)
					2:
						move_to_random_diagonal()
					3:
						move_to_random_side()
			else:
				move(next_pos.x, next_pos.y)
			add_next_pos_preview()
	
	if change_int_buffer:
		if int_buffer == 0:
			int_buffer = 1
		else:
			int_buffer = 0
	
	if change_bool_buffer:
		bool_buffer = !bool_buffer

func take_hit(amount):
	health -= abs(amount)
	
	if health == 0:
		die()

func move(x, y):
	if global_position.x + x == Global.X_MAX_LIMIT or global_position.x + x == Global.X_MIN_LIMIT:
		x = 0
		y = 16
	
	global_position.x += x
	global_position.y += y
	
	if global_position.y == 464:
		GAME.show_near_firewall_alert()

func die():
	Global.earn('firewall_points', TYPE)
	Global.spawn('enemy_dying_effect', Vector2(global_position.x, global_position.y - 16), GAME)
	
	var earn = Global.spawn('earn_firewall_points', global_position, GAME)
	earn.amount_earned = Global.return_earned_firewall_points_by_enemy(TYPE)
	
	queue_free()

func verify_collision():
	for z in get_tree().get_nodes_in_group(BLOCKS_GROUP):
		if z.global_position == global_position:
			z.take_hit(1)
			take_hit(1)
			break
	
	if global_position.y >= 554:
		Global.hit_firewall(1)
		die()

func _on_tick():
	choose_movement_by_type()
	verify_collision()
