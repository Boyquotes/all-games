extends Node2D

func _ready():
	Global.set_process_bit(self, false)

func _on_Button_button_up():
	get_parent().POINTS_AREA_CONFIRMATIONS.clear()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Game.tscn")
	get_tree().paused = false
