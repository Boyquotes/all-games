extends Sprite

var DMG = 1
var DIE = true

var DIR = Vector2.ZERO

var TYPE = 'normal'#[normal, ricochet, boomerang, return=ricochet maluco, control, aim_bot]

var BOOMERANG_POINT

var bounces = 0

var magnet_factor = 0.005

func _ready():
	match TYPE:
		'boomerang':
			DIE = false
			texture = preload("res://Images/PLAYER/BOOMERANG_BULLET.png")
		'aim_bot':
			texture = preload("res://Images/PLAYER/MISSILE_BULLET.png")
	
	look_at(DIR)
	Global.set_process_bit(self, false)
	set_process(true)

func _process(_delta):
	if TYPE == 'boomerang':
		rotation += deg2rad(10)
		if BOOMERANG_POINT != null:
			if abs(global_position[0]-BOOMERANG_POINT[0]) < 8 and abs(global_position[1]-BOOMERANG_POINT[1]) < 8:
				look_at(get_tree().get_nodes_in_group("PLAYER")[0].global_position)
				DIR = Vector2(10, 0).rotated(rotation)
				BOOMERANG_POINT = null
	if TYPE == 'aim_bot':
		var enemy = null
		var distances = []
		var enemies = []
		var list = []
		for z in get_tree().get_nodes_in_group("ENEMY"):
			if z.player_in_scene == true:
				list.append(z)
		if len(list) > 0:
			for z in list:
				distances.append(global_position.distance_to(z.global_position))
				enemies.append(z)
			enemy = enemies[distances.find(distances.min())]
			look_at(lerp(global_position+DIR, enemy.global_position, magnet_factor))
			magnet_factor *= 1.01
			DIR = Vector2(10, 0).rotated(rotation)
	global_position += DIR

func _on_Area2D_body_entered(body):
	body = body.get_parent()
	if body.is_in_group("WALL"):
		if TYPE == 'ricochet' and bounces < 11:
			var last_pos = global_position - DIR
			var looking_point = Vector2.ZERO
			
			if body.get_scale()[0] < body.get_scale()[1]:
				if last_pos[0] > global_position[0]:
					looking_point = Vector2(global_position[0]-abs(global_position[0]-last_pos[0]), last_pos[1])
				if last_pos[0] < global_position[0]:
					looking_point = Vector2(global_position[0]+abs(global_position[0]-last_pos[0]), last_pos[1])
			else:
				if last_pos[1] > global_position[1]:
					looking_point = Vector2(last_pos[0], global_position[1]-abs(global_position[1]-last_pos[1]))
				if last_pos[1] < global_position[1]:
					looking_point = Vector2(last_pos[0], global_position[1]+abs(global_position[1]-last_pos[1]))
			
			DIR = Vector2(10, 0).rotated(get_angle_to(looking_point))
			bounces += 1
		elif TYPE == 'return' and bounces < 11:
			DIR = -DIR
			bounces += 1
		else:
			queue_free()
