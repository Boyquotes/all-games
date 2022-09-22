extends KinematicBody2D

#[nome do tipo, DMG, shoot delay, bulletspeed, speed, LIFE, projectile dies?, 'scene', 'bullet_scene' ...]
var TYPE = []
var last_pos = Vector2.ZERO
onready var PLAYER = get_tree().get_nodes_in_group("PLAYER")[0]
var position_index = null

func _enter_tree():
	run()

func run():
	$Progress.max_value = TYPE[5]
	$Progress.value = TYPE[5]
	$Timer.set_wait_time(TYPE[2])
	$Sprite/Area2D.set_deferred('monitoring', true)
	set_deferred('visible', true)
	Global.set_process_bit(self, true)
	$Progress.visible = false

func _process(_delta):
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
	if position_index == null:
		if global_position.distance_to(get_tree().get_nodes_in_group("PLAYER")[0].global_position) > 350:
# warning-ignore:return_value_discarded
			move_and_slide(global_position.direction_to(get_tree().get_nodes_in_group("PLAYER")[0].global_position)*TYPE[4])
	else:
		var point = Vector2(cos(position_index)*350+PLAYER.global_position[0], sin(position_index)*350+PLAYER.global_position[1])
# warning-ignore:return_value_discarded
		move_and_slide(global_position.direction_to(point)*TYPE[4])
	$Sprite.look_at(get_tree().get_nodes_in_group("PLAYER")[0].global_position)

func _on_Area2D_area_entered(area):
	area = area.get_parent()
	if area.is_in_group("PLAYER_PROJECTILE"):
		Global.play_sound('hit')
		$Progress.visible = true
		$Progress.value -= area.DMG
		Global.ADD_DMG_LABEL(area.global_position, area.DMG)
		Global.PLAYER_INFOS['exp'] += Global.PLAYER_INFOS['bullet_exp']
		Global.PLAYER_INFOS['actual_health'] += Global.PLAYER_INFOS['life_steal']*area.DMG
		if area.DIE:
			area.find_node('Timer').stop()
			#area.BACK_TO_POOL()
			area.queue_free()
		if $Progress.value <= 0:
			Global.PLAYER_INFOS['exp'] += TYPE[5]
			var generated = false
			Global.RANDOM.randomize()
			if Global.RANDOM.randi_range(0, 100)+1 <= Global.PLAYER_INFOS['find_special_weapon'] and generated == false:
				var node = preload("res://Scenes/SPECIAL_WEAPON.tscn").instance()
				Global.RANDOM.randomize()
				node.TYPE = Global.POSSIBLES_SPECIAL_WEAPONS[Global.RANDOM.randi_range(0, len(Global.POSSIBLES_SPECIAL_WEAPONS)-1)]
				node.global_position = global_position
				get_tree().get_root().add_child(node)
				generated = true
			Global.RANDOM.randomize()
			if Global.RANDOM.randi_range(0, 100)+1 <= Global.PLAYER_INFOS['find_item'] and generated == false:
				var node = preload("res://Scenes/Items/Item.tscn").instance()
				Global.RANDOM.randomize()
				node.TYPE = Global.POSSIBLES_ITEMS[Global.RANDOM.randi_range(0, len(Global.POSSIBLES_ITEMS)-1)]
				node.global_position = global_position
				get_tree().get_root().add_child(node)
				generated = true
			Global.RANDOM.randomize()
			if Global.RANDOM.randi_range(0, 100)+1 <= Global.PLAYER_INFOS['find_power_up'] and generated == false:
				var node = preload("res://Scenes/Items/Item.tscn").instance()
				Global.RANDOM.randomize()
				node.TYPE = Global.POSSIBLES_POWER_UPS[Global.RANDOM.randi_range(0, len(Global.POSSIBLES_POWER_UPS)-1)]
				node.power_up = true
				node.global_position = global_position
				get_tree().get_root().add_child(node)
				generated = true
			#if len(Global.ENEMIES_POOL[TYPE[0]]) <= 10:
			#	Global.ENEMIES_POOL[TYPE[0]].append(self)
			#	set_deferred('visible', false)
			#	set_process_bit(self, false)
			#	$Sprite/Area2D.set_deferred('monitoring', false)
			#else:
			Global.EXPLODE(global_position)
			queue_free()

func _on_Timer_timeout():
	if global_position.distance_to(get_tree().get_nodes_in_group("PLAYER")[0].global_position) < 1000 and visible == true:
		for z in $Sprite/POINTS_HANDLER.get_children():
			Global.play_sound('shoot')
			#infos = [global_position, rotation_degrees, DMG, DIE, ROTATION, SPEED, TYPE]
			Global.ADD_BULLET(TYPE[8], [z.global_position, $Sprite.rotation_degrees, TYPE[1], TYPE[6], $Sprite.rotation, TYPE[3], TYPE[8]])
		$Timer.start()
