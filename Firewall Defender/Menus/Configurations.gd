extends Node2D

var in_game = false

onready var effects_label = $GridContainer/Effects/Grid/VALUE_E
onready var music_label = $GridContainer/Music/Grid/VALUE_M

func is_in_game():
	if in_game:
		$BG.visible = false
		$LOGO.visible = false
		
		return true
	else:
		return false

func _ready():
	update_all()

func _enter_tree():
	$GridContainer/Fullscreen/Fullscreen/Grid/CheckBox.pressed = OS.is_window_fullscreen()
	
	is_in_game()

func update_audio():
	if Global.CONFIGURATIONS['effects_volume'] == 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Effects"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Effects"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), Global.CONFIGURATIONS['effects_volume']-5)
	
	
	if Global.CONFIGURATIONS['music_volume'] == 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Musics"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Musics"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musics"), Global.CONFIGURATIONS['music_volume']-5)

func update_all():
	update_audio()
	update_labels()
	verify_to_set_disabled()

func update_labels():
	effects_label.text = str(Global.CONFIGURATIONS['effects_volume'])
	music_label.text = str(Global.CONFIGURATIONS['music_volume'])

func verify_to_set_disabled():
	if Global.CONFIGURATIONS['music_volume'] == 10:
		$GridContainer/Music/Grid/Plus_m.disabled = true
	else:
		$GridContainer/Music/Grid/Plus_m.disabled = false
	
	if Global.CONFIGURATIONS['music_volume'] == 0:
		$GridContainer/Music/Grid/Minus_m.disabled = true
	else:
		$GridContainer/Music/Grid/Minus_m.disabled = false
	
	
	if Global.CONFIGURATIONS['effects_volume'] == 10:
		$GridContainer/Effects/Grid/Plus_e.disabled = true
	else:
		$GridContainer/Effects/Grid/Plus_e.disabled = false
	
	if Global.CONFIGURATIONS['effects_volume'] == 0:
		$GridContainer/Effects/Grid/Minus_e.disabled = true
	else:
		$GridContainer/Effects/Grid/Minus_e.disabled = false


func _on_Minus_e_button_up():
	Global.CONFIGURATIONS['effects_volume'] -= 1
	update_all()
	Global.play_sound('button_pressed')

func _on_Plus_e_button_up():
	Global.CONFIGURATIONS['effects_volume'] += 1
	update_all()
	Global.play_sound('button_pressed')


func _on_Minus_m_button_up():
	Global.CONFIGURATIONS['music_volume'] -= 1
	update_all()
	Global.play_sound('button_pressed')

func _on_Plus_m_button_up():
	Global.CONFIGURATIONS['music_volume'] += 1
	update_all()
	Global.play_sound('button_pressed')


func _on_Back_button_up():
	if is_in_game():
		get_tree().paused = !get_tree().paused
		visible = false
	else:
	# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Menus/MainMenu.tscn")
	Global.play_sound('button_pressed')


func _on_CheckBox_toggled(button_pressed):
	OS.set_window_fullscreen(button_pressed)
	Global.play_sound('button_pressed')
