extends Node2D

func _ready():
	Global.set_process_bit(self, false)
	#Global.CARREGAR()
	Global.HIGHEST_LEVEL = 28
	#if Global.HIGHEST_LEVEL > 0:
	#	$RIGHT.visible = true
	#	$LEFT.visible = true
	ANALYSE()
func _on_Button_button_up():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Game.tscn")
func _on_Quit_button_up():
# warning-ignore:return_value_discarded
	OS.shell_open('https://canova-games.web.app')

func ANALYSE() -> void:
	if Global.actual_level == 0:
		$level_left.visible = false
	else:
		$level_left.visible = true
	if Global.actual_wave == 0:
		$wave_left.visible = false
	else:
		$wave_left.visible = true
	if Global.actual_wave == 3:
		$wave_right.visible = false
	else:
		$wave_right.visible = true
	
	if Global.actual_wave == Global.HIGHEST_WAVE and Global.actual_level == Global.HIGHEST_LEVEL:
		$wave_right.visible = false
	
	if Global.actual_level == Global.HIGHEST_LEVEL:
		$level_right.visible = false
	else:
		$level_right.visible = true
	

func _on_LEVEL_RIGHT_button_up():
	Global.actual_level += 1
	Global.actual_wave = 0
	ANALYSE()

func _on_LEVEL_LEFT_button_up():
	Global.actual_level -= 1
	Global.actual_wave = 0
	ANALYSE()

func _on_WAVE_RIGHT_button_up():
	Global.actual_wave += 1
	ANALYSE()

func _on_WAVE_LEFT_button_up():
	Global.actual_wave -= 1
	ANALYSE()

func _on_Book_button_up():
	$Book.visible = false
	$PixelPedia.visible = true
	for z in $PixelPedia/TabContainer/Enemies/Enemies/Vbox/Grid.get_children():
		if z.get_child(1).get_name() in Global.ENEMIES_DISCOVERED:
			pass
		else:
			z.get_child(0).color = Color(0.15, 0.15, 0.15)
			z.get_child(1).text = '????????????????'
			z.get_child(2).text = '????????????????'
	for z in $PixelPedia/TabContainer/Objectives/Objectives/Vbox/Grid.get_children():
		if z.get_child(1).text in Global.OBJECTIVES_DISCOVERED:
			pass
		else:
			z.get_child(0).texture = preload("res://Images/Objectives/NULL.png")
			z.get_child(1).text = '????????????????'
			z.get_child(2).text = '????????????????'

func _on_Close_button_up():
	$PixelPedia.visible = false
	$Book.visible = true

