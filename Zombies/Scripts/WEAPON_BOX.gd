extends Node2D

var CHAR = null

func _on_Area2D_body_entered(body):
	if body.is_in_group("CHAR"):
		CHAR = body
		$Button.visible = true
		if CHAR.ATTR['points'] >= 150:
			$Button.disabled = false

func _on_Area2D_body_exited(body):
	if body.is_in_group("CHAR"):
		CHAR = null
		$Button.visible = false
		$Button.disabled = true

func _on_Button_button_up():
	CHAR.ATTR['points'] -= 150
	var arra = []
	var already_weapons = []
	for z in CHAR.find_node("Camera2D").find_node("GUI").find_node("GridContainer").get_children():
		already_weapons.append(z.SLOT['name'])
	for z in Global.WEAPON_INFOS:
		arra.append(z)
	var random = arra[randi()%len(Global.WEAPON_INFOS)]
	while random in already_weapons:
		random = arra[randi()%len(Global.WEAPON_INFOS)]
	CHAR.Add_weapon(random)
	var node = Sprite.new()
	node.set_texture(preload("res://Images/OPENED_BOX/OPPENED_BOX.png"))
	node.global_position = global_position
	get_tree().get_root().add_child(node)
	queue_free()
