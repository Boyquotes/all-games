extends RigidBody2D

var DIRECTION = Vector2.ZERO
var DMG = 1
var DIE = false
onready var node = $Projectile

func _ready():
	node.DMG = DMG
	node.DIE = true
	
	Global.set_process_bit(self, false)
	set_process(true)

var PLANET_TYPE_DISTANCE = 32
var angle = 0

func _process(_delta):
	node.global_position = Vector2(cos(angle)*PLANET_TYPE_DISTANCE+global_position[0], sin(angle)*PLANET_TYPE_DISTANCE+global_position[1])
	angle += 1*(1/PLANET_TYPE_DISTANCE)
	global_position += DIRECTION
	
