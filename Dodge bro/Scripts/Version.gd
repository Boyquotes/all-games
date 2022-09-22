extends Node2D

func _ready():
	Global.set_process_bit(self, false)
	if Global.DEMO == true:
		$Label.text = 'D'
		$Label2.text = 'E'
		$Label3.text = 'M'
		$Label4.text = 'O'
