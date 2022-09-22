extends KinematicBody2D


var ATTR = {
	'actual_health': 100,
	'max_health': 100,
	'health_regen': 0,
	'actual_mana': 0,
	'max_mana': 100,
	'defense': 0,
	'speed': 60,
	'slow': false,
	
	'reload_speed': 1,#quanto menor a reload speed, mais rápido recarrega
	
	'points': 0,
	
	'max_weapons': 2,
	'actual_weapon': 0,#0, 1, 2
	'can_fire': true,
	'LAST_POS': Vector2()
}

var velocity = Vector2()

func _ready():
	Add_weapon('pistol')
	Add_Throwable('GRENADE')
	Add_Throwable('GRENADE')
	ATTR['LAST_POS'] = global_position

func Add_weapon(weapon):
	if len($Camera2D/GUI/GridContainer.get_children()) < ATTR['max_weapons']:
		var node = preload("res://Scenes/WEAPON_SLOT.tscn").instance()
		node.GO(weapon)
		$Camera2D/GUI/GridContainer.add_child(node)
		CHANGE_WEAPON(+1)
	else:
		$Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).GO(weapon)
		$ARMA.set_texture(load($Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['img']))

func Add_Throwable(throwable: String):
	var node = preload("res://Scenes/THROWABLE_VIEWER.tscn").instance()
	node.TYPE = throwable
	$Camera2D/GUI/THROWABLES.add_child(node)

func CHANGE_WEAPON(a):
	if ATTR['actual_weapon'] + a > len($Camera2D/GUI/GridContainer.get_children())-1:
		ATTR['actual_weapon'] = 0
	elif ATTR['actual_weapon'] + a == len($Camera2D/GUI/GridContainer.get_children()):
		ATTR['actual_weapon'] = len($Camera2D/GUI/GridContainer.get_children())-1
	else:
		ATTR['actual_weapon'] += a
	$ARMA.set_texture(load($Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['img']))

func SET_PROJECTILE():
	if $AnimatedSprite/TextureProgress.visible == false:
		$Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['pent_bullets'] -= 1
		if $Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['shoot_type'] == 'commom':
			var bullet_instance = preload("res://Scenes/Projectile.tscn").instance()
			bullet_instance.position = $ARMA/ORIGEM.get_global_position()
			bullet_instance.rotation_degrees = $ARMA.rotation_degrees
			bullet_instance.apply_impulse(Vector2(), Vector2($Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['bullet_speed'], 0).rotated($ARMA.rotation))
			bullet_instance.DMG = $Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['DMG']
			get_tree().get_root().add_child(bullet_instance)
			ATTR['can_fire'] = false
			yield(get_tree().create_timer($Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['fire_rate']), "timeout")
			ATTR['can_fire'] = true
		else:
			var DIR = [-15, 0, +15]
			for z in DIR:
				var bullet_instance = preload("res://Scenes/Projectile.tscn").instance()
				bullet_instance.position = $ARMA/ORIGEM.get_global_position()
				bullet_instance.rotation_degrees = $ARMA.rotation_degrees - z
				bullet_instance.apply_impulse(Vector2(), Vector2($Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['bullet_speed'], 0).rotated($ARMA.rotation-deg2rad(z)))
				bullet_instance.DMG = $Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['DMG']
				get_tree().get_root().add_child(bullet_instance)
			ATTR['can_fire'] = false
			yield(get_tree().create_timer($Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['fire_rate']), "timeout")
			ATTR['can_fire'] = true

func RELOAD():
	$AnimatedSprite/TextureProgress.visible = true
	$AnimatedSprite/TextureProgress.max_value = $Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['reload_need']*60
	$AnimatedSprite/TextureProgress.value = 0
	while $AnimatedSprite/TextureProgress.value != $AnimatedSprite/TextureProgress.max_value:
		$AnimatedSprite/TextureProgress.value += ATTR['reload_speed']
		yield(get_tree().create_timer(0.02), "timeout")
	var value = $Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['pent_bullets']
	if $Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['bullets'] < $Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['reload']:
		$Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['pent_bullets'] += $Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['bullets']
		$Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['bullets'] = 0
	else:
		$Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['pent_bullets'] += $Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['reload'] - value
		$Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['bullets'] -= $Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['reload'] - value
	$AnimatedSprite/TextureProgress.visible = false

func _process(_delta):
	$Camera2D/GUI/FPS.text = 'FPS: ' + str(Engine.get_frames_per_second())

func _physics_process(delta):
	if abs(ATTR['LAST_POS'][0] - global_position[0]) >= 10 or abs(ATTR['LAST_POS'][1] - global_position[1]) >= 5:
		ATTR['LAST_POS'] = global_position
		Global.emit_signal("PLAYER_MOVED")
	$Camera2D/GUI/GridContainer.columns = len($Camera2D/GUI/GridContainer.get_children())
	if ATTR['actual_health'] <= 0:
		ATTR['actual_health'] = 0
		#DIE
	if ATTR['actual_health'] > ATTR['max_health']:
		ATTR['actual_health'] = ATTR['max_health']
	$Camera2D/GUI/POINTS.text = str(ATTR['points'])
	$Camera2D/GUI/LIFE_AND_MANA/LIFEBAR/Label.text = str(ATTR['actual_health']) + '/' + str(ATTR['max_health'])
	$Camera2D/GUI/LIFE_AND_MANA/MANABAR/Label.text = str(ATTR['actual_mana']) + '/' + str(ATTR['max_mana'])
	$Camera2D/GUI/LIFE_AND_MANA/LIFEBAR.max_value = ATTR['max_health']
	$Camera2D/GUI/LIFE_AND_MANA/LIFEBAR.value = ATTR['actual_health']
	$Camera2D/GUI/LIFE_AND_MANA/MANABAR.max_value = ATTR['max_mana']
	$Camera2D/GUI/LIFE_AND_MANA/MANABAR.value = ATTR['actual_mana']
	
	if Input.is_action_just_pressed("Q") and len($Camera2D/GUI/THROWABLES.get_children()) != 0:
		var bullet_instance = preload("res://Scenes/THROWABLE.tscn").instance()
		bullet_instance.position = $ARMA/ORIGEM.get_global_position()
		bullet_instance.rotation_degrees = $ARMA.rotation_degrees
		bullet_instance.apply_impulse(Vector2(), Vector2(400, 0).rotated($ARMA.rotation))
		bullet_instance.TYPE = $Camera2D/GUI/THROWABLES.get_child(0).TYPE
		$Camera2D/GUI/THROWABLES.get_child(0).queue_free()
		get_tree().get_root().add_child(bullet_instance)
	
	if Input.is_action_just_pressed("R") and $Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['bullets'] != 0 and $AnimatedSprite/TextureProgress.visible == false and $Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['pent_bullets'] != $Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['reload']:
		RELOAD()
	
	if Input.is_action_just_pressed("ROLL_UP") and $AnimatedSprite/TextureProgress.visible == false:
		CHANGE_WEAPON(+1)
	$Camera2D/GUI/PENT.text = str($Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['pent_bullets'])
	$Camera2D/GUI/BULLETS.text = '/' + str($Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['bullets'])
	
	if $Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['pent_bullets'] == 0 and $Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['bullets'] != 0 and $AnimatedSprite/TextureProgress.visible == false:
		RELOAD()
	
	if $Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['fire_rate'] == 0:
		if Input.is_action_just_pressed("CLICK") and ATTR['can_fire'] and $Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['pent_bullets'] != 0:
			SET_PROJECTILE()
	else:
		if Input.is_action_pressed("CLICK") and ATTR['can_fire'] and $Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['pent_bullets'] != 0:
			SET_PROJECTILE()
	$Camera2D.global_position = lerp(global_position, get_global_mouse_position(), delta*15)
	#$Camera2D.global_position = lerp($Camera2D.global_position, self.global_position, 0.5)
	if get_global_mouse_position()[0] > global_position[0]:
		$ARMA.look_at(get_global_mouse_position())
		$AnimatedSprite.flip_h = false
		$ARMA.flip_h = false
		$ARMA.flip_v = false
	else:
		$ARMA.look_at(get_global_mouse_position())
		$AnimatedSprite.flip_h = true
		$ARMA.flip_v = true
	var input_dir: Vector2 = Vector2.ZERO
	
	input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_dir = input_dir.normalized()
	if input_dir != Vector2.ZERO:
		$AnimatedSprite.play("RUN")
		velocity = (ATTR['speed']-$Camera2D/GUI/GridContainer.get_child(ATTR['actual_weapon']).SLOT['weight']) * input_dir
	else:
		$AnimatedSprite.play('IDLE')
		velocity = Vector2.ZERO
	velocity = move_and_slide(velocity)
