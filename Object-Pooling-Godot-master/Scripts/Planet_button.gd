extends Button

func _on_Planet_button_button_up():
	get_tree().get_nodes_in_group("MAIN")[0].emit_signal("Planet_added", text)
	queue_free()
