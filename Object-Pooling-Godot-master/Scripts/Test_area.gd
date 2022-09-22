extends Node2D

var X = [448, 832]
var Y = [128, 552]

var CAMERA_SPEED = 5

var ManageList = []
var ManageIndex = 0

func _ready():
	add_user_signal('BUY_button_pressed', ['item'])
# warning-ignore:return_value_discarded
	connect('BUY_button_pressed', self, "_on_BUY_button_pressed")
	add_user_signal('Planet_added', ['planet'])
# warning-ignore:return_value_discarded
	connect('Planet_added', self, "_on_Planet_added")

func ManagePlanet(who):
	var textures = {
		'Solido': '',
		'Liquido': '',
		'Gasoso': '',
		'Life': '',
	}
	$Camera2D/Build_planets/TabContainer/Manage/ScrollContainer/VBoxContainer/GridContainer/GridContainer/GridContainer/GridContainer/TextureRect.texture = load(textures[who.INFOS['type']])
	$Camera2D/Build_planets/TabContainer/Manage/ScrollContainer/VBoxContainer/GridContainer/GridContainer/GridContainer/GridContainer/GridContainer/Label.text = 'TYPE: '+ who.INFOS['type']
	$Camera2D/Build_planets/TabContainer/Manage/ScrollContainer/VBoxContainer/GridContainer/GridContainer/GridContainer/GridContainer/GridContainer/Label2.text = 'LEVEL: '+ str(who.INFOS['lvl'])
	$Camera2D/Build_planets/TabContainer/Manage/ScrollContainer/VBoxContainer/GridContainer/GridContainer/GridContainer/GridContainer/GridContainer/Label3.text = 'EXPERIENCE: '+ str(who.INFOS['exp'])+'/'+str(who.INFOS['lvl']*20)
	$Camera2D/Build_planets/TabContainer/Manage/ScrollContainer/VBoxContainer/GridContainer/GridContainer/GridContainer/GridContainer/GridContainer/Label4.text = 'MASS: '+ str(who.INFOS['mass'])
	

func _on_Planet_added(planet):
	var id = ObjectPoolManager.get("Planet")
	var Planet = instance_from_id(id)
	Planet.SET(planet)
	Planet.global_position = $Camera2D.global_position

func _on_BUY_button_pressed(item):
	var text = $Camera2D/Build_planets/TabContainer/Build/ScrollContainer/VBoxContainer/GridContainer.find_node(item).find_node('Value').text.split('\n', true, 1)
	var confirm = true
	for x in text:
		var tex = x.split('-', true, 1)
		if Global.INVENTORY[tex[0]] < int(tex[1]):
			confirm = false
			break
	if confirm:
		$Camera2D/Build_planets/TabContainer/Build/ScrollContainer/VBoxContainer/GridContainer.find_node(item).find_node('BUY').disabled = false
	else:
		$Camera2D/Build_planets/TabContainer/Build/ScrollContainer/VBoxContainer/GridContainer.find_node(item).find_node('BUY').disabled = true
	$Camera2D/Build_planets/TabContainer/Build/ScrollContainer/VBoxContainer/GridContainer.find_node(item).find_node('Value').text = ''
	for x in range(0, len(text)):
		var tex = text[x].split('-', true, 1)
		Global.INVENTORY[tex[0]] -= int(tex[1])
		$Camera2D/Build_planets/TabContainer/Build/ScrollContainer/VBoxContainer/GridContainer.find_node(item).find_node('Value').text += tex[0]+'-'+tex[1]
		if x != len(text)-1:
			$Camera2D/Build_planets/TabContainer/Build/ScrollContainer/VBoxContainer/GridContainer.find_node(item).find_node('Value').text += '\n'
	Global.PLANETS[item] += 1
	var node = preload("res://Scenes/Planet_button.tscn").instance()
	node.text = item
	$Camera2D/Planets/ScrollContainer/VBoxContainer/PLANETS.add_child(node)

func _on_Timer_timeout():
	var x = randi()%2
	var y = randi()%2
	if x == 0:
		x = -1
	if y == 0:
		y = -1
	var id = ObjectPoolManager.get("Asteroid")
	var Asteroid = instance_from_id(id)
	Asteroid.global_position = Vector2($Camera2D.global_position[0]+700*x, $Camera2D.global_position[1]+700*y)
	$Timer.start()

func _process(_delta):
	if ManageIndex >= len(ManageList):
		ManageIndex = len(ManageList)-1
	if ManageIndex == 0:
		$Camera2D/Build_planets/TabContainer/Manage/ScrollContainer/VBoxContainer/GridContainer/GridContainer/INDEX_BACK.disabled = true
	else:
		$Camera2D/Build_planets/TabContainer/Manage/ScrollContainer/VBoxContainer/GridContainer/GridContainer/INDEX_BACK.disabled = false
	if ManageIndex == len(ManageList)-1:
		$Camera2D/Build_planets/TabContainer/Manage/ScrollContainer/VBoxContainer/GridContainer/GridContainer/INDEX_FORWARD.disabled = true
	else:
		$Camera2D/Build_planets/TabContainer/Manage/ScrollContainer/VBoxContainer/GridContainer/GridContainer/INDEX_FORWARD.disabled = false
	
	for z in $Camera2D/Build_planets/TabContainer/Build/ScrollContainer/VBoxContainer/GridContainer/ITEMS.get_children():
		var text = z.find_node('Value').text.split('\n', true, 1)
		var confirm = true
		for x in text:
			var tex = x.split('-', true, 1)
			if Global.INVENTORY[tex[0]] < int(tex[1]):
				confirm = false
				break
		if confirm:
			z.find_node('BUY').disabled = false
		else:
			z.find_node('BUY').disabled = true
	if Input.is_action_just_pressed("B"):
		$Camera2D/Build_planets.visible = !$Camera2D/Build_planets.visible
	if Input.is_action_just_pressed("P"):
		var already = false
		if $Camera2D/Planets.position[0] == 640 and already == false:
			while $Camera2D/Planets.position[0] != 496:
				$Camera2D/Planets.position[0] -= 8
				yield(get_tree().create_timer(0.025), "timeout")
			already = true
		if $Camera2D/Planets.position[0] == 496 and already == false:
			while $Camera2D/Planets.position[0] != 640:
				$Camera2D/Planets.position[0] += 8
				yield(get_tree().create_timer(0.025), "timeout")
			already = true
	$Camera2D.global_position += Vector2((Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")), (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))).normalized()*CAMERA_SPEED

func _on_INDEX_BACK_button_up():
	ManageIndex -= 1
	ManagePlanet(ManageList[ManageIndex])

func _on_INDEX_FORWARD_button_up():
	ManageIndex += 1
	ManagePlanet(ManageList[ManageIndex])


