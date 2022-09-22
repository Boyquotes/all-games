extends Node2D

var actual_command = ''
var infinite = false
var sound_sequence = []

func SET_COMMAND(txt: String):
	if Global.desafio_atual == 'traducao' or Global.desafio_atual == 'tutorial' or Global.desafio_atual == 'story':
		if Global.language == 'pt-br':
			#OS.shell_open("http://godotengine.org")
			pass#change txt
		for z in txt:
			var characteres_sounds = Global.Characteres_sounds
			for x in characteres_sounds:
				if z == x:
					sound_sequence.append(characteres_sounds[z])
	if Global.desafio_atual == 'escrita':
		if Global.language == 'pt-br':
			pass#change txt
		$GridContainer/Telas/Display.text = txt

func ANALYSE_ANSWER():
	if Global.desafio_atual == 'traducao':
		if $GridContainer/Telas/TextEdit.text == Global.DESAFIO_DE_TRADUCAO[str(Global.estagio_desafio_de_traducao)]:
			Global.estagio_desafio_de_traducao += 1
			SET_CHALLENGE()
			$GridContainer/GridContainer2/SELECTOR/level/Label2.text = str(Global.estagio_desafio_de_traducao)
			if Global.language == 'pt-br':
				$GridContainer/Telas/TextEdit.text = 'Boa tradução!'
			else:
				$GridContainer/Telas/TextEdit.text = 'Nice translation!'
			$GridContainer/Telas/Display.text = ''
		else:
			if Global.language == 'pt-br':
				$GridContainer/Telas/TextEdit.text = 'Está errado!'
			else:
				$GridContainer/Telas/TextEdit.text = 'Wrong translation!'
	if Global.desafio_atual == 'tutorial':
		if $GridContainer/Telas/TextEdit.text == Global.TUTORIAL[str(Global.estagio_tutorial)]:
			Global.estagio_tutorial += 1
			if len(Global.TUTORIAL) != Global.estagio_tutorial:
				SET_CHALLENGE()
			else:
				SET_CHALLENGE()
			$GridContainer/GridContainer2/SELECTOR/level/Label2.text = str(Global.estagio_tutorial)
			if Global.language == 'pt-br':
				$GridContainer/Telas/TextEdit.text = 'Boa tradução!'
			else:
				$GridContainer/Telas/TextEdit.text = 'Nice translation!'
			$GridContainer/Telas/Display.text = ''
		else:
			if Global.language == 'pt-br':
				$GridContainer/Telas/TextEdit.text = 'Está errado!'
			else:
				$GridContainer/Telas/TextEdit.text = 'Wrong translation!'
	if Global.desafio_atual == 'escrita':
		var sequencia_list = []
		for z in Global.DESAFIO_DE_ESCRITA[str(Global.estagio_desafio_de_escrita)]:
			var characteres_sounds = Global.Characteres_sounds
			for x in characteres_sounds:
				if z == x:
					for y in characteres_sounds[z]:
						sequencia_list.append(y)
					if z != ' ':
						sequencia_list.append(' ')
		sequencia_list.pop_back()
		var sequencia = ''
		for z in sequencia_list:
			sequencia += z
		if $GridContainer/Telas/TextEdit.text == sequencia:
			Global.estagio_desafio_de_escrita += 1
			SET_CHALLENGE()
			$GridContainer/GridContainer2/SELECTOR/level/Label2.text = str(Global.estagio_desafio_de_escrita)
			if Global.language == 'pt-br':
				$GridContainer/Telas/TextEdit.text = 'Boa escrita!'
			else:
				$GridContainer/Telas/TextEdit.text = 'Nice writing!'
			$GridContainer/Telas/Display.text = ''
		else:
			if Global.language == 'pt-br':
				$GridContainer/Telas/TextEdit.text = 'Está errado!'
			else:
				$GridContainer/Telas/TextEdit.text = 'Wrong phrase!'
	if Global.desafio_atual == 'story':
		var sequencia_list = []
		for z in Global.STORY_MODE[str(Global.STORY_MODE_LEVEL)]:
			var characteres_sounds = Global.Characteres_sounds
			for x in characteres_sounds:
				if z == x:
					for y in characteres_sounds[z]:
						sequencia_list.append(y)
					if z != ' ':
						sequencia_list.append(' ')
		sequencia_list.pop_back()
		var sequencia = ''
		for z in sequencia_list:
			sequencia += z
		if $GridContainer/Telas/TextEdit.text == sequencia:
			Global.STORY_MODE_LEVEL += 1
			Global.SAVE()
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Scenes/Desafio_de_tradução.tscn")
			$GridContainer/GridContainer2/SELECTOR/level/Label2.text = str(Global.STORY_MODE_LEVEL)
			if Global.language == 'pt-br':
				$GridContainer/Telas/TextEdit.text = 'Tradução enviada!'
			else:
				$GridContainer/Telas/TextEdit.text = 'Translation sent!'
			$GridContainer/Telas/Display.text = ''
		else:
			if Global.language == 'pt-br':
				$GridContainer/Telas/TextEdit.text = 'Tem algo errado!'
			else:
				$GridContainer/Telas/TextEdit.text = "That's something wrong!"

func _ready():
	if Global.language == 'pt-br':
		if Global.desafio_atual == 'traducao':
			$GridContainer/GridContainer2/Label.text = 'Desafio de tradução'
		elif Global.desafio_atual == 'tutorial':
			$GridContainer/GridContainer2/Label.text = 'Tutorial'
		else:
			$GridContainer/GridContainer2/Label.text = 'Desafio de escrita'
		$GridContainer/GridContainer2/SELECTOR/level/Label.text = 'Nível'
		$GridContainer/GridContainer2/SELECTOR/PREVIOUS.text = 'Anterior'
		$GridContainer/GridContainer2/SELECTOR/NEXT.text = 'Próximo'
		$GridContainer/SEND.text = 'Enviar'
		$GridContainer/GridContainer2/GUIDE.text = 'Dicionário'
	else:
		if Global.desafio_atual == 'traducao':
			$GridContainer/GridContainer2/Label.text = 'Translation challenge'
		elif Global.desafio_atual == 'tutorial':
			$GridContainer/GridContainer2/Label.text = 'Tutorial'
		elif Global.desafio_atual == 'story':
			$GridContainer/GridContainer2/Label.text = 'Story challenge'
		else:
			$GridContainer/GridContainer2/Label.text = 'Writing challange'
	if Global.FEZ_TUTORIAL == true:
		if Global.desafio_atual == 'traducao':
			SET_COMMAND(Global.DESAFIO_DE_TRADUCAO[str(Global.estagio_desafio_de_traducao)])
			$GridContainer/GridContainer2/SELECTOR/level/Label2.text = str(Global.estagio_desafio_de_traducao)
		elif Global.desafio_atual == 'story':
			$GridContainer/GridContainer2/SELECTOR/level/Label2.text = str(Global.STORY_MODE_LEVEL)
			var dialoge = Dialogic.start('C_' + str(Global.STORY_MODE_LEVEL))
			dialoge.connect("dialogic_signal", self, "dialog_listener")
			call_deferred('add_child', dialoge)
			$GridContainer/GridContainer2/SELECTOR/NEXT.disabled = true
			$GridContainer/GridContainer2/SELECTOR/PREVIOUS.disabled = true
			$GridContainer/GridContainer2/GridContainer.visible = false
		else:
			SET_COMMAND(Global.DESAFIO_DE_ESCRITA[str(Global.estagio_desafio_de_escrita)])
			$GridContainer/GridContainer2/SELECTOR/level/Label2.text = str(Global.estagio_desafio_de_escrita)
	else:
		$GridContainer/GridContainer2/Label.text = 'Tutorial'
		$Tutorial_area.visible = true
		$AudioStreamPlayer.set_stream(load("res://Sounds/Dot_0.wav"))
		$AudioStreamPlayer.set_volume_db(-6)
		for x in len(Global.tutorial_text):
			$Tutorial_area/GridContainer/Label2.text = ''
			$Tutorial_area/GridContainer/OK.disabled = true
			for z in Global.tutorial_text[str(x)]:
				$AudioStreamPlayer.play()
				$Tutorial_area/GridContainer/Label2.text += z
				yield(get_tree().create_timer(0.01), "timeout")
			$Tutorial_area/GridContainer/OK.disabled = false
			yield($Tutorial_area/GridContainer/OK, "button_up")
		$Tutorial_area.visible = false
		$AudioStreamPlayer.set_volume_db(0)
		Global.desafio_atual = 'tutorial'
		Global.FEZ_TUTORIAL = true
		SET_COMMAND(Global.TUTORIAL[str(Global.estagio_tutorial)])
		Global.SAVE()

func _process(_delta):
	$GridContainer/GridContainer2/GridContainer/Label.text = str(Global.STARS)
	if Global.max_estagio_desafio_de_traducao == Global.estagio_desafio_de_traducao and Global.desafio_atual == 'traducao':
		$GridContainer/GridContainer2/SELECTOR/NEXT.disabled = true
	else:
		$GridContainer/GridContainer2/SELECTOR/NEXT.disabled = false
	if Global.max_estagio_desafio_de_escrita == Global.estagio_desafio_de_escrita and Global.desafio_atual == 'escrita':
		$GridContainer/GridContainer2/SELECTOR/NEXT.disabled = true
	else:
		$GridContainer/GridContainer2/SELECTOR/NEXT.disabled = false
	if Global.max_estagio_tutorial == Global.estagio_tutorial and Global.desafio_atual == 'tutorial':
		$GridContainer/GridContainer2/SELECTOR/NEXT.disabled = true
	else:
		$GridContainer/GridContainer2/SELECTOR/NEXT.disabled = false
	if Global.estagio_desafio_de_traducao == 1 and Global.desafio_atual == 'traducao':
		$GridContainer/GridContainer2/SELECTOR/PREVIOUS.disabled = true
	else:
		$GridContainer/GridContainer2/SELECTOR/PREVIOUS.disabled = false
	if Global.estagio_desafio_de_escrita == 1 and Global.desafio_atual == 'escrita':
		$GridContainer/GridContainer2/SELECTOR/PREVIOUS.disabled = true
	else:
		$GridContainer/GridContainer2/SELECTOR/PREVIOUS.disabled = false
	if Global.estagio_tutorial == 1 and Global.desafio_atual == 'tutorial':
		$GridContainer/GridContainer2/SELECTOR/PREVIOUS.disabled = true
	else:
		$GridContainer/GridContainer2/SELECTOR/PREVIOUS.disabled = false
	if len(sound_sequence) != 0 and $AudioStreamPlayer.playing == false:
		var a
		$GO_TO_MAIN_MENU.disabled = true
		$GridContainer/SEND.disabled = true
		for z in sound_sequence:
			var last: String
			for x in z:
				if x == ' ':
					a = "res://Sounds/Space.wav"
					last = x
				elif x == '.':
					a = "res://Sounds/Dot_0.wav"
				elif x == '-':
					a = "res://Sounds/Line.wav"
				$AudioStreamPlayer.set_stream(load(a))
				$AudioStreamPlayer.play()
				$GridContainer/Telas/Display.text += x
				yield($AudioStreamPlayer, "finished")
			if last != ' ':
				$GridContainer/Telas/Display.text += ' '
				$AudioStreamPlayer.set_stream(load("res://Sounds/Space.wav"))
				$AudioStreamPlayer.play()
				yield($AudioStreamPlayer, "finished")
		if infinite == false:
			sound_sequence.clear()
		$GO_TO_MAIN_MENU.disabled = false
		$GridContainer/SEND.disabled = false

func _on_SEND_button_up():
	ANALYSE_ANSWER()

func SET_CHALLENGE():
	if Global.max_estagio_desafio_de_traducao < Global.estagio_desafio_de_traducao:
		Global.max_estagio_desafio_de_traducao = Global.estagio_desafio_de_traducao
		Global.STARS += 1
	if Global.max_estagio_desafio_de_escrita < Global.estagio_desafio_de_escrita:
		Global.max_estagio_desafio_de_escrita = Global.estagio_desafio_de_escrita
		Global.STARS += 1
	if Global.max_estagio_tutorial < Global.estagio_tutorial:
		Global.max_estagio_tutorial = Global.estagio_tutorial
	
	if Global.desafio_atual == 'traducao':
		if len(Global.DESAFIO_DE_TRADUCAO) >= Global.estagio_desafio_de_traducao:
			SET_COMMAND(Global.DESAFIO_DE_TRADUCAO[str(Global.estagio_desafio_de_traducao)])
		else:
			Global.CONGRAT = 'Translation challenge'
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Scenes/Main_menu.tscn")
	elif Global.desafio_atual == 'tutorial':
		if len(Global.TUTORIAL) >= Global.estagio_tutorial:
			SET_COMMAND(Global.TUTORIAL[str(Global.estagio_tutorial)])
		else:
			Global.CONGRAT = 'Tutorial'
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Scenes/Main_menu.tscn")
	elif Global.desafio_atual == 'story':
		if len(Global.STORY_MODE) >= Global.STORY_MODE_LEVEL:
			SET_COMMAND(Global.STORY_MODE[str(Global.STORY_MODE_LEVEL)])
		else:
			Global.CONGRAT = 'Story Challenge'
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Scenes/Main_menu.tscn")
	else:
		if len(Global.DESAFIO_DE_ESCRITA) >= Global.estagio_desafio_de_escrita:
			SET_COMMAND(Global.DESAFIO_DE_ESCRITA[str(Global.estagio_desafio_de_escrita)])
		else:
			Global.CONGRAT = 'Writing challenge'
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Scenes/Main_menu.tscn")
	
	Global.SAVE()

func _on_PREVIOUS_button_up():
	if Global.desafio_atual == 'traducao':
		Global.estagio_desafio_de_traducao -= 1
		SET_COMMAND(Global.DESAFIO_DE_TRADUCAO[str(Global.estagio_desafio_de_traducao)])
		$GridContainer/GridContainer2/SELECTOR/level/Label2.text = str(Global.estagio_desafio_de_traducao)
		$GridContainer/Telas/TextEdit.text = ''
		$GridContainer/Telas/Display.text = ''
	elif Global.desafio_atual == 'tutorial':
		Global.estagio_tutorial -= 1
		SET_COMMAND(Global.TUTORIAL[str(Global.estagio_tutorial)])
		$GridContainer/GridContainer2/SELECTOR/level/Label2.text = str(Global.estagio_tutorial)
		$GridContainer/Telas/TextEdit.text = ''
		$GridContainer/Telas/Display.text = ''
	else:
		Global.estagio_desafio_de_escrita -= 1
		SET_COMMAND(Global.DESAFIO_DE_ESCRITA[str(Global.estagio_desafio_de_escrita)])
		$GridContainer/GridContainer2/SELECTOR/level/Label2.text = str(Global.estagio_desafio_de_escrita)
		$GridContainer/Telas/TextEdit.text = ''
		$GridContainer/Telas/Display.text = ''
		


func _on_NEXT_button_up():
	if Global.desafio_atual == 'traducao':
		Global.estagio_desafio_de_traducao += 1
		SET_COMMAND(Global.DESAFIO_DE_TRADUCAO[str(Global.estagio_desafio_de_traducao)])
		$GridContainer/GridContainer2/SELECTOR/level/Label2.text = str(Global.estagio_desafio_de_traducao)
		$GridContainer/Telas/TextEdit.text = ''
		$GridContainer/Telas/Display.text = ''
	elif Global.desafio_atual == 'tutorial':
		Global.estagio_tutorial += 1
		SET_COMMAND(Global.TUTORIAL[str(Global.estagio_tutorial)])
		$GridContainer/GridContainer2/SELECTOR/level/Label2.text = str(Global.estagio_tutorial)
		$GridContainer/Telas/TextEdit.text = ''
		$GridContainer/Telas/Display.text = ''
	else:
		Global.estagio_desafio_de_escrita += 1
		SET_COMMAND(Global.DESAFIO_DE_ESCRITA[str(Global.estagio_desafio_de_escrita)])
		$GridContainer/GridContainer2/SELECTOR/level/Label2.text = str(Global.estagio_desafio_de_escrita)
		$GridContainer/Telas/TextEdit.text = ''
		$GridContainer/Telas/Display.text = ''

func _on_GUIDE_toggled(button_pressed):
	if button_pressed == true:
		$GUIDE.visible = true
	else:
		$GUIDE.visible = false

func _on_GO_TO_MAIN_MENU_button_up():
	MobileAds.show_interstitial()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Main_menu.tscn")



func dialog_listener(string):
	match string:
		'start':
			SET_COMMAND(Global.STORY_MODE[str(Global.STORY_MODE_LEVEL)])

