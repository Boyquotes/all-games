extends Sprite

var TYPE
var DIR
var DAMAGE

var bufferToShoot = 0

func _ready():
	SetDir()
	TYPE = ['Physical', 'Magic'][Global.RANDOM.randi_range(0, 1)]
	DAMAGE = Global.RANDOM.randi_range(1, floor(Global.SNAKE.LEVEL*0.75)+1)
	Global.set_process_bit(self, false)

func Shoot():
	bufferToShoot += 1
	if bufferToShoot == 10:
		bufferToShoot = 0
		#shoot
		SetDir()

func SetDir(last: Vector2 = Vector2.ZERO):
	var possibilities = [Vector2(16, 0), Vector2(-16, 0), Vector2(0, -16), Vector2(0, 16)]
	if last != Vector2.ZERO:
		possibilities.remove(possibilities.find(last))
	var choosen = possibilities[Global.RANDOM.randi_range(0, len(possibilities)-1)]
	DIR = choosen
	$Sprite.look_at(DIR)
	$Sprite.position = DIR
