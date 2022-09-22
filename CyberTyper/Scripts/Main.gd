extends Node2D

var node
var score = 0
var streak = 0
var wpm = 0
#[nice, good, great, incredible, awesome, insane, godlike, Perfect, bro?, are you ok?, You need to stop!, I will collapse!!, Colapsed]

func _ready():
	Global.set_process_bit(self, false)
	set_process(true)
	node = $WORDS.get_children()[0]

func _process(_delta):
	$SCORE.text = str(score)
	$STREAK.text = str(streak)
	$WPM.text = str(wpm)
	if streak > Global.HIGHEST_STREAK:
		Global.HIGHEST_STREAK = streak
	if score > Global.HIGHEST_SCORE:
		Global.HIGHEST_STREAK = score
	if wpm > Global.HIGHEST_WPM:
		Global.HIGHEST_WPM = wpm

func _on_INPUT_text_entered(_new_text):
	node = $WORDS.get_children()[0]
	ANALYSE()
	$GridContainer/INPUT.text = ''

func _on_INPUT_text_changed(new_text):
	node = $WORDS.get_children()[0]
	if $GridContainer/INPUT.text == node.get_child(0).text:
		node.color = Color(0, 0.65098, 0.054902)
	else:
		node.color = Color(0.717647, 0, 0)
	if len(new_text) != 0:
		if new_text[-1] == ' ':
			var splito = $GridContainer/INPUT.text.split(' ')
			$GridContainer/INPUT.text = splito[0]
			ANALYSE()
			$GridContainer/INPUT.text = ''
		if len(new_text) <= len(node.get_child(0).text):
			var confirm = true
			for z in range(0, len(new_text)):
				if new_text[z] != node.get_child(0).text[z]:
					confirm = false
			if confirm == false:
				node.color = Color(0.717647, 0, 0)
			else:
				node.color = Color(0.729412, 0.752941, 0)
			if new_text == node.get_child(0).text:
				node.color = Color(0, 0.65098, 0.054902)
		else:
			node.color = Color(0.717647, 0, 0)

func ADD_WORD() -> void:
	node.queue_free()
	node = $WORDS.get_children()[0]
	$WORDS.get_children()[0].set_process(true)
	var randu = Global.RANDOM.randi_range(0, len(Global.LENGTHS[str(Global.actual_max_length)])-1)
	var word_node = preload("res://Scenes/WordModel.tscn").instance()
	word_node.TEXT = Global.LENGTHS[str(Global.actual_max_length)][randu]
	$WORDS.call_deferred("add_child", word_node)

func ANALYSE() -> void:
	node = $WORDS.get_children()[0]
	if $GridContainer/INPUT.text == node.get_child(0).text:
		ADD_WPM()
	else:
		score -= 1
		streak = 0
		if score < 0:
			score = 0
	ADD_WORD()

func ANALYSE_TEXT() -> void:
	var buffer = $TEXTS.text
	
	if wpm <= 20:
		$TEXTS.text = 'Nice'
	if wpm <= 30 and wpm > 20:
		$TEXTS.text = 'Good'
	if wpm <= 45 and wpm > 30:
		$TEXTS.text = 'Great'
	if wpm <= 55 and wpm > 45:
		$TEXTS.text = 'Incredible'
	if wpm <= 68 and wpm > 55:
		$TEXTS.text = 'Awesome'
	if wpm <= 80 and wpm > 68:
		$TEXTS.text = 'Insane'
	if wpm <= 100 and wpm > 80:
		$TEXTS.text = 'Godlike'
	if wpm <= 125 and wpm > 100:
		$TEXTS.text = 'Perfect'
	if wpm <= 155 and wpm > 125:
		$TEXTS.text = 'Bro?'
	if wpm <= 170 and wpm > 155:
		$TEXTS.text = 'Are you ok?'
	if wpm <= 180 and wpm > 170:
		$TEXTS.text = 'You need to stop!'
	if wpm <= 190 and wpm > 180:
		$TEXTS.text = 'I will collapse!!'
	if wpm >= 200:
		$TEXTS.text = 'Colapsed'
	
	if buffer != $TEXTS.text:
		$TEXTCHANGE.play("Up")

func ADD_WPM() -> void:
	score += 1
	streak += 1
	wpm += 1
	ANALYSE_TEXT()
	yield(get_tree().create_timer(60), "timeout")
	wpm -= 1

func _on_Button_button_up():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Menu.tscn")

