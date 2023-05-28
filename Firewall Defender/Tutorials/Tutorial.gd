extends Node2D

var tutorial_name = ''

var forced = false

func _ready():
	$GridContainer/GridContainer/Label.text = Global.TUTORIAL[tutorial_name][0]
	
	$GridContainer/Imagem_do_tutorial.set_texture(load(Global.TUTORIAL[tutorial_name][1]))
	
	$GridContainer/OK.disabled = true
	
	get_tree().paused = true
	
	for _z in range(0, 100):
		yield(get_tree().create_timer(0.03), "timeout")
		$TextureProgress.value += 1

func _on_OK_button_up():
	if forced:
		queue_free()
	else:
		get_tree().paused = false
		
		if tutorial_name == 'brutus':
			Global.show_tutorial('shield')
		
		if tutorial_name == 'shield':
			Global.show_tutorial('como_jogar')
		
		queue_free()

func _on_Timer_timeout():
	$GridContainer/OK.disabled = false
	Global.play_sound('button_pressed')
