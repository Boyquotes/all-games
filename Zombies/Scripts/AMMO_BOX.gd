extends Node2D

var TIMES = 1
var CHAR = null

func _on_Area2D_body_entered(body):
	if body.is_in_group("CHAR"):
		CHAR = body
		$Button.visible = true
		$Button/Label.text = str(100*TIMES)
		if CHAR.ATTR['points'] >= 100*TIMES:
			$Button.disabled = false

func _on_Area2D_body_exited(body):
	if body.is_in_group("CHAR"):
		CHAR = null
		$Button.visible = false
		$Button.disabled = true

func _on_Button_button_up():
	CHAR.ATTR['points'] -= 100*TIMES
	CHAR.find_node("Camera2D").find_node("GUI").find_node("GridContainer").get_child(CHAR.ATTR['actual_weapon']).SLOT['bullets'] += CHAR.find_node("Camera2D").find_node("GUI").find_node("GridContainer").get_child(CHAR.ATTR['actual_weapon']).SLOT['reload']
	TIMES += 1
