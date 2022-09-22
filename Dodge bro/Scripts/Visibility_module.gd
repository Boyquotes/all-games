extends VisibilityNotifier2D

export(bool) var Bullet

func _on_Visibility_module_screen_entered():
	get_parent().visible = true

func _on_Visibility_module_screen_exited():
	if Bullet:
		get_parent().queue_free()
	else:
		get_parent().visible = false
