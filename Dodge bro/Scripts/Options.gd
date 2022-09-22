extends Node2D

func _ready():
	$GridContainer/GridContainer2/Fullscreen.pressed = OS.window_fullscreen
	$GridContainer/MUSIC/Music.value = AudioServer.get_bus_volume_db(2)
	$GridContainer/EFFECTS/Effects.value = AudioServer.get_bus_volume_db(1)

func _on_Back_button_up():
	visible = false

func _on_Fullscreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed

func _on_Effects_value_changed(value):
	Global.CONFIGURATIONS['effects_volume'] = value
	AudioServer.set_bus_volume_db(1, value)
	$GridContainer/EFFECTS/VALUE.text = str(AudioServer.get_bus_volume_db(1)+10)
	if value == -10:
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)

func _on_Music_value_changed(value):
	Global.CONFIGURATIONS['music_volume'] = value
	AudioServer.set_bus_volume_db(2, value)
	$GridContainer/MUSIC/VALUE.text = str(AudioServer.get_bus_volume_db(2)+10)
	if value == -10:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)
