extends Node2D

var INFOS = {
	'range': 0,
	
	'health_dmg': 0,
	'health_trepass': 0,
	'armor_dmg': 0,
	'armor_trepass': 0,
	'shield_dmg': 0,
	'shield_trepass': 0,
	
	'projectile_health': 0,
	'shoot_delay': 0,#in seconds
	
	'type': 'basic',
	'mode': 'first',
	'can_shoot': true,
	
	'upgrade_price': 0,
}

var RANGE_LIST = []

func _ready():
	#set_physics_process(false)
	ChangeBaseColor()
	ChangeGunTexture()
	match INFOS['type']:
		'basic':
			INFOS['range'] = 32
			INFOS['projectile_health'] = 1
			INFOS['shoot_delay'] = 0.6
		'dispersor':
			INFOS['range'] = 28
			INFOS['projectile_health'] = 1
			INFOS['shoot_delay'] = 0.4
		'flat':
			INFOS['range'] = 24
			INFOS['projectile_health'] = 2
			INFOS['shoot_delay'] = 0.8

func UPGRADE(what: String, value):
	pass
	#$Area2D/CollisionShape2D.get_shape().radius = INFOS['range']

func ChangeBaseColor() -> void:
	var ALL: float = (INFOS['armor_dmg'] + INFOS['health_dmg'] + INFOS['shield_dmg'])
	$Base.set_modulate(Color(INFOS['armor_dmg']/ALL, INFOS['health_dmg']/ALL, INFOS['shield_dmg']/ALL, 1))

func ChangeGunTexture():
	$Gun.set_texture(load(Global.TEXTURES[INFOS['type']+'_tower_gun']))

func _process(_delta):
	if len(RANGE_LIST) != 0:
		if INFOS['can_shoot'] == true:
			var node = preload("res://Scenes/Projectile.tscn").instance()
			node.INFOS['direction'] = global_position.direction_to(RANGE_LIST[0].global_position)
			
			node.INFOS['health_dmg'] = INFOS['health_dmg']
			node.INFOS['health_trepass'] = INFOS['health_trepass']
			node.INFOS['armor_dmg'] = INFOS['armor_dmg']
			node.INFOS['armor_trepass'] = INFOS['armor_trepass']
			node.INFOS['shield_dmg'] = INFOS['shield_dmg']
			node.INFOS['shield_trepass'] = INFOS['shield_trepass']
			node.INFOS['projectile_health'] = INFOS['projectile_health']
			
			node.global_position = $Gun/TIP.global_position
			get_tree().get_nodes_in_group("MAIN")[0].call_deferred("add_child", node)
			INFOS['can_shoot'] = false
			$Timer.set_wait_time(INFOS['shoot_delay'])
			$Timer.start()
		$Gun.look_at(RANGE_LIST[0].global_position)

func _physics_process(_delta):
	global_position = Vector2(stepify(get_global_mouse_position()[0], 8), stepify(get_global_mouse_position()[1], 8))

func _on_Button_button_down():
	$Handler.visible = true
	$Handler/Radius.set_scale(Vector2(INFOS['range']/($Handler/Radius.get_size()[0]/2), INFOS['range']/($Handler/Radius.get_size()[1]/2)))
	get_tree().get_nodes_in_group('CAMERA')[0].emit_signal("TowerView", self)
	set_physics_process(true)

func _on_Button_button_up():
	$Handler.visible = false
	set_physics_process(false)
	var distances = []
	for z in get_tree().get_nodes_in_group('TOWERPOINT'):
		var do = true
		for x in get_tree().get_nodes_in_group('TOWER'):
			if x.global_position == z.global_position and x != self:
				do = false
				break
		if do == true:
			distances.append(global_position.distance_to(z.global_position))
		else:
			distances.append(99999)
	global_position = get_tree().get_nodes_in_group("TOWERPOINT")[distances.find(distances.min())].global_position

func _on_RANGE_area_entered(area):
	area = area.get_parent()
	if area.is_in_group("ENEMY"):
		RANGE_LIST.append(area)

func _on_RANGE_area_exited(area):
	area = area.get_parent()
	if area.is_in_group("ENEMY"):
		RANGE_LIST.remove(RANGE_LIST.find(area))

func _on_Timer_timeout():
	INFOS['can_shoot'] = true
