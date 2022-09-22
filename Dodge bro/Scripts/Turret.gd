extends KinematicBody2D

var INFOS = {
	'max_health': 20,
	'actual_health': 20,
}

onready var PLAYER = get_tree().get_nodes_in_group("PLAYER")[0]
var can_shoot = false
var player_in_scene = false
var last_pos = Vector2.ZERO

var ORIGIN_NODE = null


export(bool) var CAN_MOVE = false
export(float) var SPEED = 50
export(float) var BULLET_DELAY = 1
export(bool) var SHOOT = true
export(int) var BULLET_SPEED = 480
export(PackedScene) var BULLET_TYPE
export(String) var SHOOT_DIR = 'normal'#[normal dir, random dir, clockwise dir, counterclockwise, opposite]

var DIR = Vector2.ZERO

func _enter_tree():
	run()

func run():
	$Sprite/Area2D.set_deferred('monitoring', true)
	set_deferred('visible', true)
	Global.set_process_bit(self, false)
	$Timer.set_wait_time(BULLET_DELAY)

func AIM(node) -> void :
	match SHOOT_DIR:
		'normal':
			node.look_at(PLAYER.global_position)
		'random':
			node.look_at(Vector2(Global.RANDOM.randf_range(-1, 1)+global_position[0], Global.RANDOM.randf_range(-1, 1)+global_position[1]))
		'clockwise':
			node.rotation_degrees += 1
		'counterclockwise':
			node.rotation_degrees -= 1
		'opposite':
			var d = Vector2(PLAYER.global_position.direction_to(global_position)[0]+global_position[0], PLAYER.global_position.direction_to(global_position)[1]+global_position[1])
			node.look_at(d)

func _process(_delta):
	if player_in_scene == true:
		if CAN_MOVE:
			AIM($Sprite)
			var Y = global_position[1] - last_pos[1]
			var X = global_position[0] - last_pos[0]
			if Y < 0: Y*=-1
			if X < 0: X*=-1
			if X >= 16 or Y >= 16:
				last_pos = global_position
				for z in $Sprite/PARTICLES_HANDLER.get_children():
					var particle = preload("res://Scenes/Particle.tscn").instance()
					particle.position = z.global_position
					particle.rotation_degrees = $Sprite.rotation_degrees
					get_tree().get_root().add_child(particle)
			#if global_position.distance_to(get_tree().get_nodes_in_group("PLAYER")[0].global_position) > 350:
# warning-ignore:return_value_discarded
			move_and_slide(DIR*SPEED)
			#global_position += DIR*1.5
		else:
			AIM($Sprite/Gun)
		if can_shoot == true and SHOOT == true:
			Global.play_sound('shoot')
			#SHOOT
			var node = BULLET_TYPE.instance()
			node.DMG = 1
			node.DIE = true
			node.global_position = $Sprite/Gun/POINT.global_position
			if CAN_MOVE:
				node.rotation_degrees = $Sprite.rotation_degrees
				node.set_linear_velocity(Vector2(BULLET_SPEED, 0).rotated($Sprite.rotation))
			else:
				node.rotation_degrees = $Sprite/Gun.rotation_degrees
				node.set_linear_velocity(Vector2(BULLET_SPEED, 0).rotated($Sprite/Gun.rotation))
			can_shoot = false
			get_tree().get_root().call_deferred("add_child", node)
			$Timer.start()
			#SHOOT

func _on_Area2D_area_entered(area):
	area = area.get_parent()
	if area.is_in_group("PLAYER_PROJECTILE") and player_in_scene:
		Global.play_sound('hit')
		Global.ADD_DMG_LABEL(area.global_position, area.DMG)
		INFOS['actual_health'] -= area.DMG
		if area.DIE:
			#area.BACK_TO_POOL()
			area.queue_free()
		if INFOS['actual_health'] <= 0:
			Global.EXPLODE(global_position)
			ORIGIN_NODE.ENEMIES_LIST.remove(ORIGIN_NODE.ENEMIES_LIST.find(self))
			ORIGIN_NODE.ANALYSE()
			queue_free()

func _on_Timer_timeout():
	can_shoot = true
	$Timer.stop()
