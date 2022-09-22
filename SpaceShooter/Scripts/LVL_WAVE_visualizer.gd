extends Node2D

export(String) var TYPE = 'actual'

func _ready():
	Global.set_process_bit(self, false)
	set_process(true)

func _process(_delta):
	match TYPE:
		'actual':
			if Global.actual_level >= 10:
				$LVL.text = str(Global.actual_level)[0]
				$LVL2.text = str(Global.actual_level+1)[-1]
			else:
				$LVL.text = '0'
				$LVL2.text = str(Global.actual_level+1)
			if Global.actual_wave >= 10:
				$WAVE.text = str(Global.actual_wave)[0]
				$WAVE2.text = str(Global.actual_wave+1)[-1]
			else:
				$WAVE.text = '0'
				$WAVE2.text = str(Global.actual_wave+1)
		'highest':
			if Global.HIGHEST_LEVEL >= 10:
				$LVL.text = str(Global.HIGHEST_LEVEL)[0]
				$LVL2.text = str(Global.HIGHEST_LEVEL+1)[-1]
			else:
				$LVL.text = '0'
				$LVL2.text = str(Global.HIGHEST_LEVEL+1)
			
			if Global.HIGHEST_WAVE >= 10:
				$WAVE.text = str(Global.HIGHEST_WAVE)[0]
				$WAVE2.text = str(Global.HIGHEST_WAVE+1)[-1]
			else:
				$WAVE.text = '0'
				$WAVE2.text = str(Global.HIGHEST_WAVE+1)
