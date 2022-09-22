extends Node2D
var position_index = null
var can_fire = true
onready var PLAYER = get_tree().get_nodes_in_group("PLAYER")[0]
var nearest_enemy = null

func _ready():
	if position_index == null:
		position_index = Global.PLAYER_INFOS['allies']

func _process(delta):
	var distances = []
	for z in get_tree().get_nodes_in_group("ENEMY"):
		distances.append(PLAYER.global_position.distance_to(z.global_position))
	if distances.find(distances.min()) != -1:
		nearest_enemy = get_tree().get_nodes_in_group("ENEMY")[distances.find(distances.min())].global_position
	if nearest_enemy != null:
		$".".look_at(nearest_enemy)
	if can_fire:
		Global.play_sound('shoot')
		var bullet_instance = load(Global.PLAYER_INFOS['bullet_type']).instance()
		bullet_instance.position = $POINT.global_position
		bullet_instance.rotation_degrees = $".".rotation_degrees
		bullet_instance.DMG = Global.PLAYER_INFOS['bullet_dmg']*0.25
		bullet_instance.apply_impulse(Vector2(), Vector2(Global.PLAYER_INFOS['bullet_speed'], 0).rotated($".".rotation))
		get_tree().get_root().add_child(bullet_instance)
		can_fire = false
		yield(get_tree().create_timer(5), "timeout")
		can_fire = true
	global_position = lerp(global_position, Vector2(cos(position_index)*96+PLAYER.global_position[0], sin(position_index)*96+PLAYER.global_position[1]), delta*2)
