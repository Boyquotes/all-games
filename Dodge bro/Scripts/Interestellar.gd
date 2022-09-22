extends KinematicBody2D

const BULLETS_LIST = ['normal', 'boomerang', 'ricochet', 'return', 'aim_bot']
var ACTUAL_BULLET_TYPE = 0

const INTERESTELLAR = true
var can_fire = true
var auto_fire = false
var last_pos = Vector2.ZERO

var SPEED = 200
var pause = false
var can_dash = true

func _process(_delta):
	
	#if Input.is_action_just_pressed("1"):
	#	ACTUAL_BULLET_TYPE = 0
	#if Input.is_action_just_pressed("2"):
	#	ACTUAL_BULLET_TYPE = 1
	#if Input.is_action_just_pressed("3"):
	#	ACTUAL_BULLET_TYPE = 2
	#if Input.is_action_just_pressed("4"):
	#	ACTUAL_BULLET_TYPE = 3
	#if Input.is_action_just_pressed("5"):
	#	ACTUAL_BULLET_TYPE = 4
	
	#if Input.is_action_just_pressed("M"):
	#	for z in get_tree().get_nodes_in_group("ENEMY_PROJECTILE"):
	#		z.queue_free()
	#if Input.is_action_just_pressed("N"):
	#	for z in get_tree().get_nodes_in_group("ENEMY"):
	#		z.queue_free()
	var Y = global_position[1] - last_pos[1]
	var X = global_position[0] - last_pos[0]
	if Y < 0: Y*=-1
	if X < 0: X*=-1
	if X >= 16 or Y >= 16:
		last_pos = global_position
		var particle = preload("res://Scenes/Particle.tscn").instance()
		particle.position = $Sprite/PARTICLES_POINT.global_position
		particle.rotation_degrees = $Sprite.rotation_degrees
		get_tree().get_root().add_child(particle)
	if Input.is_action_just_pressed("ESC"):
		pause = true
	if Input.is_action_just_pressed("E"):
		auto_fire = !auto_fire
	
	if can_dash and Input.is_action_just_pressed("SPACE"):
		SPEED = 850
		can_dash = false
		for _z in range(0, 20):
			var particle = preload("res://Scenes/Particle.tscn").instance()
			particle.position = $Sprite/PARTICLES_POINT.global_position
			particle.rotation_degrees = $Sprite.rotation_degrees
			get_tree().get_root().add_child(particle)
		$DASH.start()
		yield(get_tree().create_timer(0.15), "timeout")
		SPEED = 200
	
	#$PauseArea.global_position = lerp(global_position, get_global_mouse_position(), 0.2)
	var input_dir: Vector2 = Vector2.ZERO
	input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_dir = input_dir.normalized()
	if input_dir != Vector2.ZERO:
# warning-ignore:return_value_discarded
		move_and_slide(input_dir*SPEED)
		#global_position += input_dir*Global.PLAYER_INFOS['speed']
	if Input.is_action_pressed("CLICK") and can_fire == true or auto_fire == true and can_fire:
		Global.play_sound('shoot')
		#infos = [global_position, rotation_degrees, DMG, DIE, ROTATION, SPEED, TYPE]
		var node = preload("res://Scenes/InterestellarProjectile.tscn").instance()
		node.global_position = $Sprite/Gun/POINT.global_position
		node.rotation_degrees = $Sprite/Gun.rotation_degrees
		node.DIR = Vector2(10, 0).rotated($Sprite/Gun.rotation)
		match BULLETS_LIST[ACTUAL_BULLET_TYPE]:
			'boomerang':
				node.BOOMERANG_POINT = get_global_mouse_position()
				node.DIR = Vector2(10, 0).rotated(get_angle_to(get_global_mouse_position()))
		node.TYPE = BULLETS_LIST[ACTUAL_BULLET_TYPE]
		#node.set_linear_velocity(Vector2(600, 0).rotated($Sprite/Gun.rotation))
		get_tree().get_root().call_deferred("add_child", node)
		can_fire = false
		yield(get_tree().create_timer(Global.PLAYER_INFOS['shoot_delay']), "timeout")
		can_fire = true
	$Sprite/Gun.look_at(get_global_mouse_position())

func _on_Area2D_area_entered(area):
	area = area.get_parent()
	if area.is_in_group("ENEMY_PROJECTILE"):
		Global.play_sound('hit')
		Global.ADD_DMG_LABEL(area.global_position, area.DMG, true)
		Global.INTERESTELAR_INFOS['actual_health'] -= area.DMG
		if area.DIE:
			area.find_node('Timer').stop()
			#area.BACK_TO_POOL()
			area.queue_free()
		$AnimationPlayer.play("DmgTaken")
		$Area2D/CollisionShape2D.disabled = true
		yield($AnimationPlayer, "animation_finished")
		$Area2D/CollisionShape2D.disabled = false

func _on_GoToMainMenu_button_up():
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Main_menu.tscn")


func _on_DASH_timeout():
	can_dash = true
	$DASH.stop()
