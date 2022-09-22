extends Node2D

var ACHIEVS = {
	'0': '5_MINUTES',
	'1': '15_MINUTES',
	'2': '30_MINUTES',
	'3': '1_HOUR',
	'4': '10_ALLIES',
}

func _ready():
	for z in ACHIEVS:
		if Steam.get_achievement(ACHIEVS[z]):
			$ScrollContainer/VBoxContainer/Achievs.get_child(int(z)).find_node("State").texture = load("res://Images/Others/SI.png")
		else:
			$ScrollContainer/VBoxContainer/Achievs.get_child(int(z)).find_node("State").texture = load("res://Images/Others/No.png")
	

func _on_Back_button_up():
	visible = false
