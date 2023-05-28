extends Node2D

onready var List = [$ColorRect/ColorRect2/Grid/GridContainer/BuyInfos/Value/Value, $ColorRect/ColorRect2/Grid/GridContainer/BuyInfos2/Value/Value, $ColorRect/ColorRect2/Grid/GridContainer/BuyInfos3/Value/Value, $ColorRect/ColorRect2/Grid/GridContainer/BuyInfos4/Value/Value, $ColorRect/ColorRect2/Grid/Choose/BuyInfos/Value/Value]
onready var Buttons = [$ColorRect/ColorRect2/Grid/GridContainer/Fis, $ColorRect/ColorRect2/Grid/GridContainer/Mag, $ColorRect/ColorRect2/Grid/GridContainer/Armor, $ColorRect/ColorRect2/Grid/GridContainer/Shield, $ColorRect/ColorRect2/Grid/Choose/SnakeLen]

func _ready():
	Global.set_process_bit(self, false)
	CanBuy()
	if len(Global.SNAKE.Parts) == 1:
		$ColorRect/ColorRect2/Grid/Choose/SnakeLen.disabled = true
		$ColorRect/ColorRect2/Grid/Choose/BuyInfos/Info.text = 'Minimum Snake Length reached'

func UpdateValues():
	for z in List:
		z.text = str(Global.ActualShopItemValue)

func CanBuy():
	if Global.SNAKE.COINS >= Global.ActualShopItemValue:
		for z in Buttons:
			z.disabled = false
	else:
		for z in Buttons:
			z.disabled = true
	UpdateValues()

func Buy(what):
	Global.SNAKE.Earn('Coin', -Global.ActualShopItemValue)
	Global.ActualShopItemValue += 1
	if what == 'SnakeLen':
		Global.SNAKE.RemovePart()
	else:
		Global.SNAKE.Earn(what, 1)
	CanBuy()

func _on_Fis_button_up():
	Buy('DmgFis')

func _on_Mag_button_up():
	Buy('DmgMag')

func _on_Armor_button_up():
	Buy('Armor')

func _on_Shield_button_up():
	Buy('Shield')

func _on_SnakeLen_button_up():
	Buy('SnakeLen')

func _on_QuitShop_button_up():
	queue_free()
