extends Node2D

func _on_Despause_button_up():
	get_tree().paused = !get_tree().paused
