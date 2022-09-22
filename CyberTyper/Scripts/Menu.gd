extends Node2D

var index = 5

func _ready():
	Global.set_process_bit(self, false)
	$H2/GridContainer/music/choose/value.text = str(index)

func _on_play_button_up():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Main.tscn")

func _on_options_button_up():
	$H2.visible = true
	$H1.visible = false

func _on_hideH2_button_up():
	$H2.visible = false
	$H1.visible = true

func _on_minus_button_up():
	AudioServer.set_bus_volume_db(0, AudioServer.get_bus_volume_db(0)-2)
	index -= 1
	$H2/GridContainer/music/choose/value.text = str(index)
	if index == 0:
		$H2/GridContainer/music/choose/minus.disabled = true
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
	$H2/GridContainer/music/choose/plus.disabled = false

func _on_plus_button_up():
	AudioServer.set_bus_volume_db(0, AudioServer.get_bus_volume_db(0)+2)
	index += 1
	$H2/GridContainer/music/choose/value.text = str(index)
	if index == 10:
		$H2/GridContainer/music/choose/plus.disabled = true
	AudioServer.set_bus_mute(0, false)
	$H2/GridContainer/music/choose/minus.disabled = false
