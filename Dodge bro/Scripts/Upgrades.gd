extends Node2D

func _ready():
	for z in Global.SHIP_UPGRADES:
		var node = preload("res://Scenes/Upgrade_structure.tscn").instance()
		node.TYPE = z
		$GridContainer/ScrollContainer/VBoxContainer/GridContainer.call_deferred("add_child", node)

func _process(_delta):
	$GridContainer/GridContainer2/GridContainer/Label.text = str(Global.PLAYER_INFOS['upgrade_parts'])

func _on_Reset_button_up():
	for z in Global.SHIP_UPGRADES:
		if Global.SHIP_UPGRADES[z][0] != 1:
			var buffer = 0
			for x in range(1, Global.SHIP_UPGRADES[z][0]):
				buffer += x*Global.SHIP_UPGRADES[z][2]
			Global.PLAYER_INFOS['upgrade_parts'] += buffer
			Global.SHIP_UPGRADES[z][0] = 1
	if Global.DEMO == false:
		Global.SALVAR()

func _on_Back_button_up():
	if Global.DEMO == false:
		Global.SALVAR()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Main_menu.tscn")
