extends Node2D

func _ready():
	if Global.DEMO == true:
		$Achivs.visible = false
	else:
		Global.CARREGAR()
		AudioServer.set_bus_volume_db(1, Global.CONFIGURATIONS['effects_volume'])
		AudioServer.set_bus_volume_db(2, Global.CONFIGURATIONS['music_volume'])
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("Idle")

func _process(_delta):
	if $Options.visible:
		$Start.visible = false
		$Upgrades.visible = false
		$Options2.visible = false
		$Quit.visible = false
	else:
		$Start.visible = true
		$Upgrades.visible = true
		$Options2.visible = true
		$Quit.visible = true

func _on_Start_button_up():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Test_area.tscn")

func _on_Options_button_up():
	$Options.visible = true

func _on_Quit_button_up():
	get_tree().quit()

func _on_Upgrades_button_up():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Upgrades.tscn")

func _on_Achivs_button_up():
	$Achievements.visible = !$Achievements.visible
