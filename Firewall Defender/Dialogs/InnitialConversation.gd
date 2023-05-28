extends Node2D

func _ready():
	Global.musics.stop()
	var new_dialog = Dialogic.start('InnitialConversation')
	add_child(new_dialog)
	Global.spawn('cloud', Vector2(-80, Global.RANDOM.randi_range(40, 168)), self)

func _on_Timer_timeout():
	Global.spawn('cloud', Vector2(-80, Global.RANDOM.randi_range(40, 168)), self)
	
	$Timer.start()
