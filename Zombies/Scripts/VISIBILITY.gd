extends VisibilityNotifier2D
func _on_VISIBILITY_screen_entered():
	get_parent().visible = true
func _on_VISIBILITY_screen_exited():
	get_parent().visible = false
