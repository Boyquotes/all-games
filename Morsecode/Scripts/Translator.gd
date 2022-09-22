extends Node2D

var sound_sequence = []
onready var output2 = $GridContainer/Translated_text/TabContainer/Separated/OUTPUT2
onready var laal = $GridContainer/Translated_text/TabContainer/Together/Label

func IDENTIFY_CHARACTERE(charactere: String):
	var characteres_sounds = Global.Characteres_sounds
	for z in characteres_sounds:
		if z == charactere:
			sound_sequence.append(characteres_sounds[z])

func ANALYSE_TEXT(txt: String):
	for z in txt:
		IDENTIFY_CHARACTERE(z)

func _ready():
	if Global.language == 'pt-br':
		$GridContainer/Text_to_be_translated/GridContainer/SEND.text = 'Traduzir'
		$GridContainer/Text_to_be_translated/GridContainer/CLEAR.text = 'Limpar'
		$GridContainer/Translated_text/OUTPUT.text = 'Tradutor'
		$GridContainer/Translated_text/TabContainer/Together.name = 'Junto'
		$GridContainer/Translated_text/TabContainer/Separated.name = 'Separado'
		$GridContainer/Text_to_be_translated/TextEdit.text = 'Escreva aqui\nPressione o botão Traduzir para obter a tradução do texto\nPressione o botão limpar para apagar todos os caracteres'

func _process(_delta):
	if len(sound_sequence) != 0 and $AudioStreamPlayer.playing == false:
		var a
		$GO_TO_MAIN_MENU.disabled = true
		$GridContainer/Text_to_be_translated/GridContainer/SEND.disabled = true
		$GridContainer/Text_to_be_translated/GridContainer/CLEAR.disabled = true
		for z in sound_sequence:
			var last: String
			for x in z:
				if x == ' ':
					a = "res://Sounds/Space.wav"
					last = x
					output2.add_child(Button.new())
				elif x == '.':
					a = "res://Sounds/Dot_0.wav"
				elif x == '-':
					a = "res://Sounds/Line.wav"
				$AudioStreamPlayer.set_stream(load(a))
				$AudioStreamPlayer.play()
				if len(output2.get_children()) == 0:
					output2.add_child(Button.new())
				if x != ' ':
					output2.get_children()[len(output2.get_children())-1].text += x
				laal.text += x
				yield($AudioStreamPlayer, "finished")
			if last != ' ':
				laal.text += ' '
				output2.get_children()[len(output2.get_children())-1].text += ' '
				$AudioStreamPlayer.set_stream(load("res://Sounds/Space.wav"))
				$AudioStreamPlayer.play()
				yield($AudioStreamPlayer, "finished")
		sound_sequence.clear()
		$GO_TO_MAIN_MENU.disabled = false
		$GridContainer/Text_to_be_translated/GridContainer/SEND.disabled = false
		$GridContainer/Text_to_be_translated/GridContainer/CLEAR.disabled = false
	for z in output2.get_children():
		if z.pressed and $AudioStreamPlayer.playing == false:
			for x in z.text:
				var b
				if x == '.':
					b = "res://Sounds/Dot_0.wav"
				elif x == '-':
					b = "res://Sounds/Line.wav"
				elif x == ' ':
					b = "res://Sounds/Space.wav"
				$AudioStreamPlayer.set_stream(load(b))
				$AudioStreamPlayer.play()
				yield($AudioStreamPlayer, "finished")

func _on_SEND_button_up():
	for z in output2.get_children():
		z.free()
	laal.text = ''
	ANALYSE_TEXT($GridContainer/Text_to_be_translated/TextEdit.text)

func _on_CLEAR_button_up():
	$GridContainer/Text_to_be_translated/TextEdit.text = ''
	for z in output2.get_children():
		z.free()
	laal.text = ''

func _on_GO_TO_MAIN_MENU_button_up():
	MobileAds.show_interstitial()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Main_menu.tscn")
	Global.SAVE()
