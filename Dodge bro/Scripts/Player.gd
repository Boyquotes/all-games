extends KinematicBody2D

const INTERESTELLAR = false
var can_fire = true
var auto_fire = false
var last_pos = Vector2.ZERO
var can_fire_special = false
var last_minute_count = 0
var can_dash = true

var speed_buff = 1

var near_index = 0
var animations_list = []

func _ready():
	add_user_signal("Upgrade_choosen", ['type', 'mega'])
# warning-ignore:return_value_discarded
	connect("Upgrade_choosen", self, "_on_Upgrade_choosen")
	add_user_signal("Item_added", ['item'])
# warning-ignore:return_value_discarded
	connect("Item_added", self, "_on_Item_added")
	add_user_signal("Power_up_gotten", ['power_up'])
# warning-ignore:return_value_discarded
	connect("Power_up_gotten", self, "_on_Power_up_gotten")
	$Progress.max_value = Global.PLAYER_INFOS['max_health']
	$Progress.value = Global.PLAYER_INFOS['max_health']
	$Camera2D/EXP.max_value = Global.PLAYER_INFOS['lvl']*50 + 50
	$Camera2D/EXP.value = Global.PLAYER_INFOS['exp']
	
	for z in Global.PLAYER_INFOS['spaceship_modules']:
		add_child(load(z).instance())
	for z in Global.SHIP_UPGRADES:
		if Global.SHIP_UPGRADES[z][0] != 1:
			for _x in range(1, Global.SHIP_UPGRADES[z][0]):
				Global.PLAYER_INFOS[z] += Global.SHIP_UPGRADES[z][1]
	Global.POSSIBLES_ENEMIES = ['Enemy']
	for z in range(0, Global.PLAYER_INFOS['allies']):
		var node = preload("res://Scenes/Allies/Ally.tscn").instance()
		node.position_index = z
		get_parent().call_deferred('add_child', node)
	Global.PLAYER_INFOS['actual_health'] = Global.PLAYER_INFOS['max_health']

func _process(_delta):
	if can_dash and Input.is_action_just_pressed("SPACE"):
		speed_buff = 2
		can_dash = false
		for _z in range(0, 20):
			var particle = preload("res://Scenes/Particle.tscn").instance()
			particle.position = $Sprite/PARTICLES_POINT.global_position
			particle.rotation_degrees = $Sprite.rotation_degrees
			get_tree().get_root().add_child(particle)
		$DASH.start()
		yield(get_tree().create_timer(0.15), "timeout")
		speed_buff = 1
	
	if $AnimationPlayer.is_playing()==false and len(animations_list)!=0:
		if animations_list[0][0] == 'Item_added':
			$Camera2D/Item_added_info/NUMS.text = animations_list[0][1]
			$Camera2D/Item_added_info/TextureRect.texture = load(animations_list[0][2])
		else:
			$Camera2D/Power_up_gotten/TextureRect.texture = load(animations_list[0][1])
			$Camera2D/Power_up_gotten/NUMS.text = animations_list[0][2]
		$AnimationPlayer.play(animations_list[0][0])
		animations_list.pop_front()
	
	if Input.is_action_just_pressed("M"):
		for z in get_tree().get_nodes_in_group("ENEMY_PROJECTILE"):
			z.queue_free()
	if Input.is_action_just_pressed("N"):
		for z in get_tree().get_nodes_in_group("ENEMY"):
			z.queue_free()
	
	
	$Camera2D.global_position = lerp(global_position, get_global_mouse_position(), 0.2)
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
		get_tree().paused = !get_tree().paused
		$Camera2D/ESC.visible = !$Camera2D/ESC.visible
		$Camera2D/ESC/RESUME.visible = !$Camera2D/ESC/RESUME.visible
	if Input.is_action_just_pressed("E"):
		auto_fire = !auto_fire
		$Camera2D/Autofire.visible = !$Camera2D/Autofire.visible
	
	
	if Input.is_action_just_pressed("RIGHT_CLICK") and can_fire_special == true and Global.PLAYER_INFOS['special_bullet'][0] != null:
		$SPECIAL_BULLET.max_value = Global.PLAYER_INFOS['special_bullet'][1]*10
		$SPECIAL_BULLET.value = 0
		var bullet_instance = load(Global.PLAYER_INFOS['special_bullet'][0]).instance()
		bullet_instance.position = $Sprite/POINT.global_position
		bullet_instance.rotation_degrees = $Sprite.rotation_degrees
		bullet_instance.DMG = Global.PLAYER_INFOS['bullet_dmg']
		bullet_instance.apply_impulse(Vector2(), Vector2(Global.PLAYER_INFOS['bullet_speed'], 0).rotated($Sprite.rotation))
		get_tree().get_root().add_child(bullet_instance)
		can_fire_special = false
		WAIT_SPECIAL_BULLET()
	
	
	var input_dir: Vector2 = Vector2.ZERO
	input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_dir = input_dir.normalized()
	if input_dir != Vector2.ZERO:
# warning-ignore:return_value_discarded
		move_and_slide(input_dir*(Global.PLAYER_INFOS['speed']*speed_buff))
	if Input.is_action_pressed("CLICK") and can_fire == true or auto_fire == true and can_fire:
		Global.play_sound('shoot')
		#infos = [global_position, rotation_degrees, DMG, DIE, ROTATION, SPEED, TYPE]
		Global.ADD_BULLET(Global.PLAYER_INFOS['bullet_type'], [$Sprite/Gun/POINT.global_position, $Sprite/Gun.rotation_degrees, Global.PLAYER_INFOS['bullet_dmg'], Global.PLAYER_INFOS['bullet_die'], $Sprite/Gun.rotation, Global.PLAYER_INFOS['bullet_speed'], Global.PLAYER_INFOS['bullet_type']])
		can_fire = false
		yield(get_tree().create_timer(Global.PLAYER_INFOS['shoot_delay']), "timeout")
		can_fire = true
	$Sprite/Gun.look_at(get_global_mouse_position())
	if Global.PLAYER_INFOS['exp'] >= Global.PLAYER_INFOS['lvl']*50+50:
		Global.PLAYER_INFOS['exp'] -= Global.PLAYER_INFOS['lvl']*50+50
		Global.PLAYER_INFOS['lvl'] += 1
		$Camera2D/EXP.max_value = Global.PLAYER_INFOS['lvl']*50 + 50
		get_tree().paused = !get_tree().paused
		$Camera2D/ESC.visible = !$Camera2D/ESC.visible
		$Camera2D/ESC/UPGRADE_AREA.visible = !$Camera2D/ESC/UPGRADE_AREA.visible
		if Global.PLAYER_INFOS['lvl']%5 == 0:
			SHOW_MEGA_UPGRADES()
		else:
			SHOW_UPGRADES()
	
	$Camera2D/EXP.value = Global.PLAYER_INFOS['exp']

func _on_RESUME_button_up():
	get_tree().paused = !get_tree().paused
	$Camera2D/ESC.visible = !$Camera2D/ESC.visible
	$Camera2D/ESC/RESUME.visible = !$Camera2D/ESC/RESUME.visible

func _on_Timer_timeout():
	if len(get_tree().get_nodes_in_group("ENEMY")) < 50:
		Global.ADD_ENEMY()

func _on_Upgrade_choosen(type, mega=false):
	get_tree().paused = !get_tree().paused
	$Camera2D/ESC.visible = !$Camera2D/ESC.visible
	$Camera2D/ESC/UPGRADE_AREA.visible = !$Camera2D/ESC/UPGRADE_AREA.visible
	if mega:
		Global.PLAYER_INFOS[type[0]] += type[1]
	else:
		Global.PLAYER_INFOS[type[0]] *= type[1]
	if type[0] == 'allies':
		get_parent().add_child(preload("res://Scenes/Allies/Ally.tscn").instance())
	var add = true
	for z in range(0, len(Global.PLAYER_INFOS['upgrades_list'])):
		if Global.PLAYER_INFOS['upgrades_list'][z][0] == type[0]:
			add = false
			$Camera2D/ESC/INFOS/VBoxContainer/GridContainer.get_child(z).get_child(1).text = str(int($Camera2D/ESC/INFOS/VBoxContainer/GridContainer.get_child(z).get_child(1).text)+type[2])
			break
	if add:
		Global.PLAYER_INFOS['upgrades_list'].append([type[0], type[2]])
		var grid = GridContainer.new()
		grid.set_h_size_flags(3)
		grid.set_columns(2)
		grid.name = type[0]
		
		var texture = TextureRect.new()
		texture.set_custom_minimum_size(Vector2(32, 32))
		texture.texture = load(type[3])
		
		var label = Label.new()
		label.set_custom_minimum_size(Vector2(32, 32))
		label.set_align(Label.ALIGN_CENTER)
		label.set_valign(Label.VALIGN_CENTER)
		label.set_h_size_flags(3)
		label.text = str(type[2])
		
		grid.add_child(texture)
		grid.add_child(label)
		$Camera2D/ESC/INFOS/VBoxContainer/GridContainer.add_child(grid)
	for z in $Camera2D/ESC/UPGRADE_AREA/HBoxContainer/GridContainer.get_children():
		z.queue_free()

func SHOW_UPGRADES():
	var possibles_upgrades = []
	
	for z in Global.UPGRADES:
		if Global.UPGRADES[z][1] != 3:
			possibles_upgrades.append(z)
	for _z in range(0, Global.PLAYER_INFOS['upgrade_cards']):
		Global.RANDOM.randomize()
		var x = possibles_upgrades[Global.RANDOM.randi_range(0, len(possibles_upgrades)-1)]
		Global.RANDOM.randomize()
		var a = Global.RANDOM.randi_range(0, 2)
		var node = preload("res://Scenes/UPGRADE.tscn").instance()
		node.TYPE = [x, Global.UPGRADES[x][a], a, Global.UPGRADES[x][3], Global.UPGRADES[x][4], Global.UPGRADES[x][5]]
		$Camera2D/ESC/UPGRADE_AREA/HBoxContainer/GridContainer.add_child(node)
		possibles_upgrades.remove(possibles_upgrades.find(x))
	$Camera2D/ESC/UPGRADE_AREA/HBoxContainer/GridContainer.set_columns(len($Camera2D/ESC/UPGRADE_AREA/HBoxContainer/GridContainer.get_children()))

func SHOW_MEGA_UPGRADES():
	var possibles_upgrades = []
	
	for z in Global.UPGRADES:
		possibles_upgrades.append(z)
	for _z in range(0, Global.PLAYER_INFOS['upgrade_cards']):
		Global.RANDOM.randomize()
		var x = possibles_upgrades[Global.RANDOM.randi_range(0, len(possibles_upgrades)-1)]
		var node = preload("res://Scenes/UPGRADE.tscn").instance()
		if Global.UPGRADES[x][1] == 3:
			#['type in string', value, rarity, 'texture', 'description', 'card name']
			node.TYPE = [x, Global.UPGRADES[x][2], 2, Global.UPGRADES[x][3], Global.UPGRADES[x][4], Global.UPGRADES[x][5]]
		else:
			node.TYPE = [x, Global.UPGRADES[x][0], 2, Global.UPGRADES[x][3], Global.UPGRADES[x][4], Global.UPGRADES[x][5]]
		var mega_list = ['allies', 'upgrade_cards']
		if x in mega_list:
			node.mega = true
		$Camera2D/ESC/UPGRADE_AREA/HBoxContainer/GridContainer.add_child(node)
		possibles_upgrades.remove(possibles_upgrades.find(x))
	$Camera2D/ESC/UPGRADE_AREA/HBoxContainer/GridContainer.set_columns(len($Camera2D/ESC/UPGRADE_AREA/HBoxContainer/GridContainer.get_children()))

func WAIT_SPECIAL_BULLET():
	$SPECIAL_BULLET.visible = true
	while $SPECIAL_BULLET.value != $SPECIAL_BULLET.max_value:
		$SPECIAL_BULLET.value += 1
		yield(get_tree().create_timer(0.1), "timeout")
	$SPECIAL_BULLET.visible = false
	can_fire_special = true

func _on_CLOCK_timeout():
	Global.PLAYER_INFOS['seconds'] += 1
	if Global.PLAYER_INFOS['seconds'] == 60:
		if Global.PLAYER_INFOS['minutes']%2==0:
			for z in Global.ENEMIES_INFOS:
				Global.ENEMIES_INFOS[z][1] *= 1.05
				Global.ENEMIES_INFOS[z][5] *= 1.05
		Global.PLAYER_INFOS['seconds'] = 0
		Global.PLAYER_INFOS['minutes'] += 1
	if Global.PLAYER_INFOS['minutes'] == 60:
		Global.PLAYER_INFOS['minutes'] = 0
		Global.PLAYER_INFOS['hours'] += 1
	
	var hr = str(Global.PLAYER_INFOS['hours'])
	var mn = str(Global.PLAYER_INFOS['minutes'])
	var sc = str(Global.PLAYER_INFOS['seconds'])
	
	if Global.PLAYER_INFOS['hours'] == 0:
		hr = '00'
	if Global.PLAYER_INFOS['minutes'] == 0:
		mn = '00'
	if Global.PLAYER_INFOS['seconds'] == 0:
		sc = '00'
	
	if Global.PLAYER_INFOS['hours'] < 10:
		hr = '0'+str(Global.PLAYER_INFOS['hours'])
	if Global.PLAYER_INFOS['minutes'] < 10:
		mn = '0'+str(Global.PLAYER_INFOS['minutes'])
	if Global.PLAYER_INFOS['seconds'] < 10:
		sc = '0'+str(Global.PLAYER_INFOS['seconds'])
	
	$Camera2D/TEMPO.text = hr+':'+mn+':'+sc
	if Global.PLAYER_INFOS['minutes'] != last_minute_count and len(Global.ENEMIES_SEQUENCE) >= Global.PLAYER_INFOS['minutes']:
		last_minute_count = Global.PLAYER_INFOS['minutes']
		Global.POSSIBLES_ENEMIES.append(Global.ENEMIES_SEQUENCE[last_minute_count-1])
	
	if Global.PLAYER_INFOS['minutes'] == 5 and Steam.get_achievement("5_MINUTES") == false:
		Steam.set_achievement("5_MINUTES")
	if Global.PLAYER_INFOS['minutes'] == 5 and Steam.get_achievement("15_MINUTES") == false:
		Steam.set_achievement("15_MINUTES")
	if Global.PLAYER_INFOS['minutes'] == 5 and Steam.get_achievement("30_MINUTES") == false:
		Steam.set_achievement("30_MINUTES")
	if Global.PLAYER_INFOS['minutes'] == 5 and Steam.get_achievement("1_HOUR") == false:
		Steam.set_achievement("1_HOUR")

func _on_Area2D_area_entered(area):
	area = area.get_parent()
	if area.is_in_group("ENEMY_PROJECTILE"):
		Global.play_sound('hit')
		Global.ADD_DMG_LABEL(area.global_position, area.DMG, true)
		$Progress.visible = true
		var value = area.DMG * Global.PLAYER_INFOS['defense']
		if value < 0:
			value = 0
		Global.PLAYER_INFOS['actual_health'] -= value
		$Progress.value -= area.DMG * Global.PLAYER_INFOS['defense']
		if area.DIE:
			area.find_node('Timer').stop()
			#area.BACK_TO_POOL()
			area.queue_free()
		if $Progress.value == 0:
			for z in Global.BASE_INFOS:
				Global.PLAYER_INFOS[z] = Global.BASE_INFOS[z]
			get_tree().paused = true
			$Camera2D/ESC/Label.visible = true
			$Camera2D/ESC.visible = true
			$Camera2D/ESC/RESUME.visible = false
			$Camera2D/ESC/GridContainer.visible = true
			if Global.DEMO == false:
				Global.SALVAR()
	if area.is_in_group("ITEM"):
		if area.power_up == false:
			Global.PLAYER_INFOS[area.TYPE] += 1
			emit_signal('Item_added', [area.TYPE, area.TEXTURES[area.TYPE][0]])
		else:
			Global.SET_POWER_UP(area.TYPE)
			emit_signal('Power_up_gotten', area.TEXTURES[area.TYPE])
		area.queue_free()
	if area.is_in_group("WEAPON"):
		area.find_node("PICK").visible = !area.find_node("PICK").visible

func _on_Item_added(item):
	animations_list.append(["Item_added", str(Global.PLAYER_INFOS[item[0]]), item[1]])

func _on_Power_up_gotten(power_up):
	animations_list.append(["Power_up_gotten", power_up[0], power_up[1]])

func _on_GoToMainMenu_button_up():
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Main_menu.tscn")

func _on_Organize_area_entered(area):
	area = area.get_parent().get_parent()
	if area.is_in_group("ENEMY"):
		area.position_index = near_index
		near_index += 1

func _on_Organize_area_exited(area):
	area = area.get_parent().get_parent()
	if area.is_in_group("ENEMY"):
		area.position_index = null
		near_index -= 1

func _on_Options_toggled(button_pressed):
	match button_pressed:
		true:
			$Camera2D/ESC/RESUME.disabled = true
			$Camera2D/ESC/Options.visible = true
		false:
			$Camera2D/ESC/RESUME.disabled = false
			$Camera2D/ESC/Options.visible = false

func _on_Area2D_area_exited(area):
	if area.is_in_group("WEAPON"):
		area.find_node("PICK").visible = !area.find_node("PICK").visible

func _on_StrongerEnemy_timeout():
	if len(get_tree().get_nodes_in_group("ENEMY")) < 50:
		Global.ADD_ENEMY(null, true)

func _on_Regen_timeout():
	Global.PLAYER_INFOS['actual_health'] += Global.PLAYER_INFOS['regen']
	$Progress.value = Global.PLAYER_INFOS['actual_health']
	if Global.PLAYER_INFOS['regen'] != 0:
		print(Global.PLAYER_INFOS['regen'])
	$Regen.start()

func _on_DASH_timeout():
	can_dash = true
	$DASH.stop()

func _on_VoidStar_timeout():
	var node = preload("res://Scenes/Voids/VoidStar.tscn").instance()
	node.global_position = Vector2(Global.RANDOM.randi_range(-683, 683), Global.RANDOM.randi_range(-383,383))+global_position
	get_parent().call_deferred("add_child", node)
	$VoidStar.start()
