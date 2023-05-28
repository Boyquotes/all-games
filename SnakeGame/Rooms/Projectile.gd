extends Sprite

var TYPE = 'Physical'#Physical or Magic
var DIR = 0
var DAMAGE = 1

const MAP_DIR = [Vector2(16, 0), Vector2(-16, 0), Vector2(0, -16), Vector2(0, 16)]
const MAP_COLOR = {
	'Physical': Color(1, 0, 0),
	'Magic': Color(0, 0, 1)
}

func _ready():
	Global.set_process_bit(self, false)
	$Pointer.position = MAP_DIR[DIR]
	$Pointer.look_at($Pointer.position + MAP_DIR[DIR])
	for z in [$Projectile, $Pointer]:
		z.set_modultate(MAP_COLOR[TYPE])

func Move():
	global_position += MAP_DIR[DIR]
	var collided = false
	if global_position == get_tree().get_nodes_in_group("SnakeHead")[0].global_position:
		collided = true
	for z in get_tree().get_nodes_in_group("SnakePart"):
		if global_position == z.global_position or collided == true:
			collided = true
			break
	if collided:
		var defense = {
			'Physical': Global.SNAKE.ARMOR,
			'Magic': Global.SNAKE.SHIELD
		}
		var calculatedDmg = DAMAGE-defense
		if calculatedDmg < 0:
			calculatedDmg = 0
		Global.SNAKE.HEALTH -= calculatedDmg
		Global.SNAKE.UpdateStats()
