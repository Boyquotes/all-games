extends Node2D

var TYPE = ''

func _ready():
	$ColorRect/ColorRect2/Grid/Label2.text = '\nLEVEL '+str(Global.SNAKE.LEVEL)
	get_tree().paused = true
	Global.set_process_bit(self, false)
	if TYPE == 'ChooseGoldenAppleReward':
		BuildGoldenAppleReward()

func Run(st, amount = 1):
	Global.SNAKE.Earn(st, amount)
	Global.SNAKE.control = true
	get_tree().paused = false
	queue_free()

func BuildGoldenAppleReward():
	$ColorRect/ColorRect2/Grid/Label2.text = '\nGolden Apple Reward'
	$ColorRect/ColorRect2/Grid/Label.text = 'Choose a Reward!'
	$ColorRect/ColorRect2/Grid/GridContainer/SnakePart.visible = true
	$ColorRect/ColorRect2/Grid/GridContainer/Exp.visible = true
	$ColorRect/ColorRect2/Grid/GridContainer/Health.visible = true
	$ColorRect/ColorRect2/Grid/GridContainer/Coin.visible = true

func _on_a1_button_up():
	Run('DmgFis')

func _on_a2_button_up():
	Run('DmgMag')

func _on_a3_button_up():
	Run('Armor')

func _on_a4_button_up():
	Run('Shield')

func _on_SnakePart_button_up():
	Run('SnakePart', 1)

func _on_Exp_button_up():
	Run('Exp', floor(Global.SNAKE.LEVEL*2)+15)

func _on_Health_button_up():
	Run('Health', floor(Global.SNAKE.LEVEL*1.5)+2)

func _on_Coin_button_up():
	Run('Coin', floor(Global.SNAKE.LEVEL*2)+8)
