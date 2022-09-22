extends Node2D

var TYPE: String

#TYPES: KNIFE, GRENADE, MOLOTOV

func _ready():
	var textures = {
		'KNIFE': "res://Images/THROWABLE/KNIFE.png",
		'GRENADE': "res://Images/THROWABLE/GRANADA.png",
		'MOLOTOV': "res://Images/THROWABLE/MOLOTOV.png",
	}
	if TYPE == 'KNIFE':
		$CollisionShape2D.disabled = true
	if TYPE == 'GRENADE':
		$Timer.set_wait_time(3)
		$Timer.start()
	if TYPE == 'MOLOTOV':
		$Timer.set_wait_time(1)
		$Timer.start()
	$Sprite.set_texture(load(textures[TYPE]))
	while self:
		if TYPE == 'GRENADE' or TYPE == 'MOLOTOV':
			self.set_rotation_degrees(self.get_rotation_degrees()+20)
		yield(get_tree().create_timer(0.05), "timeout")

func CABUM(body = null):
	if TYPE != 'KNIFE':
		var node = preload("res://Scenes/Explosion.tscn").instance()
		node.TYPE = TYPE
		node.global_position = global_position
		get_tree().get_nodes_in_group("MAIN_SCENE")[0].call_deferred("add_child", node)
		queue_free()
	else:
		body.ATTR['actual_health'] -= Global.THROWABLE_INFOS[TYPE][0] - (body.ATTR['defense']*0.5)
		body.emit_signal("HEALTH_CHANGED")

func _on_Timer_timeout():
	CABUM()


func _on_Area2D_body_entered(body):
	if body.is_in_group("WALL") and TYPE == 'KNIFE':
		queue_free()
	if body.is_in_group("ENEMY") and TYPE != 'KNIFE':
		var info_generated = preload("res://Scenes/DROP_INFO.tscn").instance()
		info_generated.text = '-' + str(Global.THROWABLE_INFOS[TYPE][0] - (Global.ENEMY_TYPES[body.TYPE][3]*0.5))
		info_generated._set_global_position(Vector2(body.global_position[0]-12, body.global_position[1]-24))
		info_generated.set_self_modulate(Color(0.756863, 0.007843, 0.007843))
		get_tree().get_nodes_in_group("MAIN_SCENE")[0].add_child(info_generated)
		CABUM(body)
		
