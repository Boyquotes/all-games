extends Node2D

export(String) var TYPE
#TYPES: HEALTH, RELOAD, SPEED
var CHAR = null
const UpValue = {
	'HEALTH': [['max_health', 'actual_health'], 50, 300],
	'SPEED': [['speed'], 10, 250],
	'RELOAD': [['reload_speed'], 0.5, 350],
	'WEAPONS': [['max_weapons'], 1, 600]
}
var points = {
	'HEALTH': 300,
	'RELOAD': 350,
	'SPEED': 250,
	'WEAPONS': 600,
}

func _ready():
	var textures = {
		'HEALTH': "res://Images/INTERACTIVE_OBJECTS/health_perk.png",
		'RELOAD': "res://Images/INTERACTIVE_OBJECTS/reload_perk.png",
		'SPEED': "res://Images/INTERACTIVE_OBJECTS/speed_perk.png",
		'WEAPONS': "res://Images/INTERACTIVE_OBJECTS/weapon_perk.png",
	}
	$TextureRect.texture = load(textures[TYPE])

func _on_Area2D_body_entered(body):
	if body.is_in_group("CHAR"):
		CHAR = body
		$Button.visible = true
		$Button/Label.text = str(points[TYPE])
		if body.ATTR['points'] >= points[TYPE]:
			$Button.disabled = false

func _on_Area2D_body_exited(body):
	if body.is_in_group("CHAR"):
		CHAR = null
		$Button.visible = false
		$Button.disabled = true

func _on_Button_button_up():
	CHAR.ATTR['points'] -= points[TYPE]
	for z in UpValue[TYPE][0]:
		CHAR.ATTR[z] += UpValue[TYPE][1]
	points[TYPE] += UpValue[TYPE][2]
	$Button.visible = true
	$Button/Label.text = str(points[TYPE])
	if CHAR.ATTR['points'] >= points[TYPE]:
		$Button.disabled = false
