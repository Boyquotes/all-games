extends Node2D

func _ready():
	#for z in 3:
	#	pass#try 3 times
	if MobileAds.get_is_banner_loaded() == false:
		Global.SET_BANNER()
	if Global.STARS >= 150:
		$GridContainer2/dialogo.disabled = false
	if Global.CONGRAT != '':
		$Congrats.visible = true
		$Congrats/GridContainer/Label.text = 'Congrats, you have concluded the ' + Global.CONGRAT + '\nSee the others challenges'
		Global.CONGRAT = ''

func _process(_delta):
	$Configurations/GridContainer2/Effects_volume/Label.text = str(AudioServer.get_bus_volume_db(1))
	$Configurations/GridContainer2/Music_volume/Label.text = str(AudioServer.get_bus_volume_db(2))
	$YOURS_STARS/Label.text = str(Global.STARS)
	if Global.volume == -5:
		$Configurations/GridContainer2/Effects_volume/minus.disabled = true
	else:
		$Configurations/GridContainer2/Effects_volume/minus.disabled = false
	if Global.music_volume == 0:
		$Configurations/GridContainer2/Music_volume/minus_music.disabled = true
	else:
		$Configurations/GridContainer2/Music_volume/minus_music.disabled = false

func _on_RATE_THE_APP_button_up():
# warning-ignore:return_value_discarded
	OS.shell_open('https://play.google.com/store/apps/details?id=com.kongregate.mobile.burritobison3.google')#+ a parte que linka até o app

func _on_Button4_button_up():
	if MobileAds.get_is_banner_loaded() == false:
		Global.SET_BANNER()
	Global.FEZ_TUTORIAL = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Desafio_de_tradução.tscn")

func _on_Button2_button_up():
	$GridContainer.visible = false
	$GridContainer2.visible = true
	if Global.STARS < 150:
		$STARS.visible = true
	$YOURS_STARS.visible = true

func _on_Button_button_up():
	if MobileAds.get_is_banner_loaded() == false:
		Global.SET_BANNER()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Translator.tscn")

func _on_Button3_button_up():
	$GridContainer.visible = false
	$Configurations/GridContainer2.visible = true

func _on_Traducao_button_up():
	if MobileAds.get_is_banner_loaded() == false:
		Global.SET_BANNER()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Desafio_de_tradução.tscn")
	Global.desafio_atual = 'traducao'

func _on_escrita_button_up():
	if MobileAds.get_is_banner_loaded() == false:
		Global.SET_BANNER()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Desafio_de_tradução.tscn")
	Global.desafio_atual = 'escrita'

func _on_dialogo_button_up():
	if MobileAds.get_is_banner_loaded() == false:
		Global.SET_BANNER()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Desafio_de_tradução.tscn")
	Global.desafio_atual = 'story'

func _on_Return_button_up():
	$GridContainer.visible = true
	$GridContainer2.visible = false
	$Configurations/GridContainer2.visible = false
	$STARS.visible = false
	$YOURS_STARS.visible = false

func _on_plus_button_up():
	AudioServer.set_bus_volume_db(1, AudioServer.get_bus_volume_db(1)+1)
	$AudioStreamPlayer.play()
	$Configurations/GridContainer2/Effects_volume/Label.text = str(AudioServer.get_bus_volume_db(1)+5)
	Global.volume = AudioServer.get_bus_volume_db(1)

func _on_minus_button_up():
	AudioServer.set_bus_volume_db(1, AudioServer.get_bus_volume_db(1)-1)
	$AudioStreamPlayer.play()
	$Configurations/GridContainer2/Effects_volume/Label.text = str(AudioServer.get_bus_volume_db(1)+5)
	Global.volume = AudioServer.get_bus_volume_db(1)

func _on_asdasd_button_up():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://addons/admob/test/Example.tscn")

func _on_Music_toggled(button_pressed):
	Global.MUSIC = button_pressed
	if button_pressed == true:
		$Example/Music.play()

func _on_minus_music_button_up():
	AudioServer.set_bus_volume_db(2, AudioServer.get_bus_volume_db(2)-1)
	$Configurations/GridContainer2/Music_volume/Label.text = str(AudioServer.get_bus_volume_db(2))
	Global.music_volume = AudioServer.get_bus_volume_db(2)

func _on_plus_music_button_up():
	AudioServer.set_bus_volume_db(2, AudioServer.get_bus_volume_db(2)+1)
	$Configurations/GridContainer2/Music_volume/Label.text = str(AudioServer.get_bus_volume_db(2))
	Global.music_volume = AudioServer.get_bus_volume_db(2)

func _on_AD_button_up():
	MobileAds.show_rewarded()

func _on_THANKS_CONGRATS_button_up():
	$Congrats.visible = false
