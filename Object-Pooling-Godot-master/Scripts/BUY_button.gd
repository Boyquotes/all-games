extends Button

func _on_BUY_button_up():
	get_tree().get_nodes_in_group("MAIN")[0].emit_signal('BUY_button_pressed', get_parent().get_name())
