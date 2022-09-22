extends Node2D

var INFOS = {
	'type': '',
	'lvl': 1,
	'exp': 0,
	'mass': 10,
}
var attractive = true
var AttractRadius = 0

var nome = []

var killed = false

var control = false

func obj_reset():
	visible = false
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	self.remove_from_group('Planet')
	get_tree().get_nodes_in_group("MAIN")[0].ManageList.remove(get_tree().get_nodes_in_group("MAIN")[0].ManageList.find(self))
	set_process(false)

func obj_set():
	self.add_to_group("Planet")
	attractive = true
	control = false
	$Timer.start()
	visible = true
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
	get_tree().get_nodes_in_group("MAIN")[0].ManageList.append(self)
	set_process(true)
	killed = false

func _ready():
	obj_set()

func SET(type):
	var value = 0
	match type:
		'Gasoso':
			value = 2
		'Solido':
			value = 10
		'Liquido':
			value = 5
	INFOS['mass'] = value
	INFOS['type'] = type
	$ProgressBar.max_value = INFOS['lvl']*20
	$ProgressBar.value = 0

var angle = 0
var rotate = 1

func _process(_delta):
	AttractRadius = INFOS['mass']*10
	$TextureButton.set_rotation_degrees($TextureButton.get_rotation_degrees()+rotate)
	var high_radius = self
	for z in get_tree().get_nodes_in_group("Planet"):
		if z.global_position.distance_to(global_position) <= z.AttractRadius and z != self:
			if z.AttractRadius > high_radius.AttractRadius:
				high_radius = z
				z.attractive = true
				attractive = false
	if high_radius == self:
		attractive = true
		rotate = 1
	if control:
		global_position = get_global_mouse_position()
	else:
		if attractive == false:
			global_position = Vector2(cos(angle)*high_radius.global_position.distance_to(global_position)+high_radius.global_position[0], sin(angle)*high_radius.global_position.distance_to(global_position)+high_radius.global_position[1])
			var mini = high_radius.global_position.distance_to(global_position)
			if mini == 0:
				mini = 1
			angle += 1*(1/mini)
			rotate = 300*(2/mini)
	if INFOS['exp'] >= INFOS['lvl']*20:
		INFOS['exp'] -= INFOS['lvl']*20
		INFOS['lvl'] += 1
		INFOS['mass'] += 1
		$ProgressBar.max_value = INFOS['lvl']*20
		$ProgressBar.value = INFOS['exp']

func _on_TextureButton_button_down():
	control = true

func _on_TextureButton_button_up():
	control = false

func _on_Timer_timeout():
	Global.INVENTORY[Global.ITEM_BY_TYPE[INFOS['type']][randi()%len(Global.ITEM_BY_TYPE[INFOS['type']])]] += 1*INFOS['lvl']
	if visible == true:
		$Timer.start()

func _on_Area2D_area_entered(area):
	area = area.get_parent()
	if area.is_in_group("Planet") and area.INFOS['type'] == INFOS['type'] and control == false and area.control == false and killed == false:
		area.control = true
		INFOS['exp'] += area.INFOS['exp'] + area.INFOS['lvl']*20
		$ProgressBar.value += area.INFOS['exp'] + area.INFOS['lvl']*20
		$ProgressBar.visible = true
		Global.KILL(area)
