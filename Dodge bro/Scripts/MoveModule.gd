extends Area2D

export(float) var EXTENSION = 300

export(String) var MODE_OUTSIDE_AREA = 'aproximar'
export(String) var MODE_INSIDE_AREA = 'afastar'

onready var PLAYER = get_tree().get_nodes_in_group("PLAYER")[0]
var DIR = 'aproximar'

var last_angle:float = 0.0
var THE_POINT = Vector2.ZERO

func _ready():
	DIR = MODE_OUTSIDE_AREA
	THE_POINT = global_position
	Global.RANDOM.randf_range(0, 360)
	$CollisionShape2D.get_shape().radius = EXTENSION
	Global.set_process_bit(self, false)
	set_process(true)

func _process(_delta):
	if get_parent().player_in_scene == true:
		match DIR:
			'aproximar':
				get_parent().DIR = global_position.direction_to(PLAYER.global_position)
			'afastar':
				get_parent().DIR = PLAYER.global_position.direction_to(global_position)
			'rodar':
				var point = Vector2(cos(last_angle)*350+THE_POINT[0], sin(last_angle)*350+THE_POINT[1])
				get_parent().DIR = global_position.direction_to(point)
				last_angle += 0.01
				if last_angle == 360:
					last_angle = 0
			'parado':
				get_parent().DIR = Vector2.ZERO

func _on_MoveModule_area_entered(area):
	area = area.get_parent()
	if area.is_in_group("PLAYER"):
		DIR = MODE_INSIDE_AREA

func _on_MoveModule_area_exited(area):
	area = area.get_parent()
	if area.is_in_group("PLAYER"):
		DIR = MODE_OUTSIDE_AREA
