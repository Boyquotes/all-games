extends RigidBody2D

var DMG = 0
var explosion = preload("res://Scenes/Explosion.tscn")

func _on_Area2D_body_entered(body):
	if body.is_in_group("WALL"):
		queue_free()
	if body.is_in_group("CHAR"):
		body.find_node("Camera2D").find_node("GUI").find_node("GridContainer").get_child(body.ATTR['actual_weapon']).SLOT['bullets'] += 1
		queue_free()
	if body.is_in_group("ENEMY"):
		var DANO = DMG - (Global.ENEMY_TYPES[body.TYPE][3]*0.5)
		if DANO < 0:
			DANO = 0
		body.ATTR['actual_health'] -= DANO
		get_tree().get_nodes_in_group("CHAR")[0].ATTR['points'] += 1
		var info_generated = preload("res://Scenes/DROP_INFO.tscn").instance()
		info_generated.text = '-' + str(DANO)
		info_generated._set_global_position(Vector2(body.global_position[0]-12, body.global_position[1]-24))
		info_generated.set_self_modulate(Color(0.756863, 0.007843, 0.007843))
		get_tree().get_nodes_in_group("MAIN_SCENE")[0].add_child(info_generated)
		body.emit_signal("HEALTH_CHANGED")
