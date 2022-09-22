extends Node2D

var scene = preload("res://Scenes/GAME.tscn")

func _on_Button_button_up():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/GAME.tscn")
