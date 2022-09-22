extends TextureButton

export(String) var where

func _on_CLOSE_BUTTON_button_up():
	get_tree().get_nodes_in_group("GAME")[0].emit_signal("CLOSE_BUTTON_PRESSED", where)
