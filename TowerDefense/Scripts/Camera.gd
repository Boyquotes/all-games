extends Camera2D

func _ready():
	add_user_signal('TowerView', ['tower'])
# warning-ignore:return_value_discarded
	connect("TowerView", self, "_on_TowerView")
	for z in Global.ALL_BASIC_TOWERS_TYPES:
		var node = preload("res://Scenes/PickTower.tscn").instance()
		node.INFOS['type'] = z
		$Handler/ScrollContainer/VBoxContainer/GridContainer.call_deferred('add_child', node)

func _on_TowerView(tower):
	pass

func _process(_delta):
	$Handler/INFOS/ROUND/Label.text = 'Round: '+str(Global.INFOS['actual_round'])
	$Handler/INFOS/GEARS/Label.text = str(Global.INFOS['gears'])
	$Handler/INFOS/LIFE/Label.text = str(Global.INFOS['actual_life'])
	if Input.is_action_just_pressed("WHEEL_UP"):
		zoom = Vector2(zoom[0]-0.1, zoom[1]-0.1)
		set_scale(Vector2(get_scale()[0]-0.1, get_scale()[1]-0.1))
	if Input.is_action_just_pressed("WHEEL_DOWN"):
		zoom = Vector2(zoom[0]+0.1, zoom[1]+0.1)
		set_scale(Vector2(get_scale()[0]+0.1, get_scale()[1]+0.1))
	var input_dir: Vector2 = Vector2.ZERO
	input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_dir = input_dir.normalized()
	if input_dir != Vector2.ZERO:
		global_position += input_dir*(10-(Input.get_action_strength("SHIFT")*7))
	if len(get_tree().get_nodes_in_group("ENEMY"))==0:
		$Handler/TIME/PassTurn.disabled = false
	else:
		$Handler/TIME/PassTurn.disabled = true

func _on_PassTurn_button_up():
	$Handler/TIME/PassTurn.disabled = true
	get_tree().get_nodes_in_group("MAIN")[0].PassTurn()
