extends GridContainer

var INFOS = {
	'type': '',
}

var PRICES = {
	'basic': 50,
	'dispersor': 70,
	'flat': 60,
}

func _enter_tree():
	$TextureRect.texture = load(Global.TEXTURES[INFOS['type']+'_tower_icon'])
	$GridContainer/Label.text = str(PRICES[INFOS['type']])

func _process(_delta):
	if Global.INFOS['gears'] < PRICES[INFOS['type']]:
		$TextureRect/TextureButton.disabled = true
	else:
		$TextureRect/TextureButton.disabled = false

func _on_TextureButton_button_up():
	var node = preload("res://Scenes/Tower.tscn").instance()
	node.INFOS['type'] = INFOS['type']
	if $VSlider.value == 0:
		node.INFOS['health_dmg'] += 1
	elif $VSlider.value == 1:
		node.INFOS['armor_dmg'] += 1
	elif $VSlider.value == 2:
		node.INFOS['shield_dmg'] += 1
	node.global_position = get_global_mouse_position()
	Global.INFOS['gears'] -= PRICES[INFOS['type']]
	get_tree().get_nodes_in_group('MAIN')[0].call_deferred('add_child', node)


