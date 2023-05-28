extends Node

func _ready():
	Global.set_process_bit(self, false)

func _on_Timer_timeout():
	#Global.Spawn('fruit')
	$Timer.start()

func Substituir(_node):
	pass
