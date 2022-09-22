extends Node2D
func _on_Shoot_timeout():
	$Shoot.start()
	for z in get_children():
		if z.get_name() != 'Shoot':
			var bullet_instance = load("res://Scenes/PlayerProjectile.tscn").instance()
			bullet_instance.position = z.global_position
			bullet_instance.rotation_degrees = get_parent().rotation_degrees-int(z.get_name())*45
			bullet_instance.DMG = Global.PLAYER_INFOS['bullet_dmg']
			bullet_instance.apply_impulse(Vector2(), Vector2(Global.PLAYER_INFOS['bullet_speed'], 0).rotated(get_parent().rotation-deg2rad(int(z.get_name())*45)))
			get_tree().get_root().add_child(bullet_instance)
	$Shoot.start()
