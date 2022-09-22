extends Sprite

var Level: int
var direction = Vector2.ZERO
var speed: float

func _ready():
	Global.set_process_bit(self, false)
	set_process(true)
	speed = [0.5, 0.75, 1, 1.25, 1.5][Level]
	
	set_scale(Vector2(speed, speed))
	look_at(direction)

func _process(_delta):
	if speed > 0:
		global_position += direction * speed
		speed -= 0.01
	else:
		if Level > 1:
			var node = load("res://Scenes/WaveEffect.tscn").instance()
			node.direction = direction
			node.global_position = global_position + direction*4
			node.Level = Level-1
			get_parent().call_deferred("add_child", node)
		queue_free()
