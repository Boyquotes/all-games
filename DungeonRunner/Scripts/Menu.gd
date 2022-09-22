extends Node2D

func _ready():
	#Global.set_process_bit(self, false)
	set_process(false)
	set_physics_process(false)
	pass

const KEYS = ['B', 'C', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'U', 'V', 'W', 'X', 'Y', 'Z']

func _unhandled_key_input(event):
	if OS.get_scancode_string(event.scancode) in KEYS:
	# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/Main.tscn")

func _on_Play_button_up():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Main.tscn")
