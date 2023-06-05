extends TextureRect

var parentReference: Object
var waitTime: float = 4.0
var pointingCooldown = ''

@onready var HOVER = $Hover


const TEXTURES = {
	'super_jump': "res://Textures/UI/SuperJump.png",
	'punch': "res://Textures/UI/Punch.png",
	'slam': "res://Textures/UI/Slam.png",
}

func _ready():
	await self.ready
	
	texture = load(TEXTURES[pointingCooldown])
	
	runCooldown()

func updateHoverAttrs(y):
	HOVER._set_size(Vector2(48, y))
	HOVER._set_position(Vector2(0, 48 - y))

func runCooldown():
	HOVER.visible = true
	
	var buffer = 0
	var y = 0
	
	updateHoverAttrs(y)
	
	for z in 100:
		buffer += 0.01
		y = 48 * buffer
		await get_tree().create_timer(waitTime/100).timeout
		updateHoverAttrs(y)
	
	parentReference.CAN[pointingCooldown][0] = true
	
	HOVER.visible = false
