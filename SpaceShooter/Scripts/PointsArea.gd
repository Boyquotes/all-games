extends Node2D

var index: float = 0.1
var entered = false
var CONCLUDED = false

var point
var DIR

var PENTAGON_STATE = 'null'

var TYPE = ''

const TEXTURES = {
	'Square': ["res://Images/Objectives/SquareObjective.png", "res://Images/Objectives/SquareObjectiveFILL.png"],
	'Diamond': ["res://Images/Objectives/OrangeObjective.png", "res://Images/Objectives/OrangeObjectiveFILL.png"],
	'Triangle': ["res://Images/Objectives/GreenObjective.png", "res://Images/Objectives/GreenObjectiveFILL.png"],
	'Circle': ["res://Images/Objectives/PurpleObjective.png", "res://Images/Objectives/PurpleObjectiveFILL.png"],
	'Pentagon': ["res://Images/Objectives/PentagonObjective.png", "res://Images/Objectives/PentagonObjectiveFILL.png"],
	'Dot': ["res://Images/Objectives/DotObjective.png", "res://Images/Objectives/DotObjectiveFILL.png"],
}

func _enter_tree():
	point = global_position

func _ready():
	Global.set_process_bit(self, false)
	set_process(true)
	$FILL.texture = load(TEXTURES[TYPE][1])
	$FILL2.texture = load(TEXTURES[TYPE][1])
	$OBJECTIVE.texture = load(TEXTURES[TYPE][0])
	$FILL.set_modulate(Color(1, 1, 1, index))
	if TYPE == 'Dot':
		$FILL.set_scale(Vector2(0.5, 0.5))
		$FILL2.set_scale(Vector2(0.5, 0.5))
		$OBJECTIVE.set_scale(Vector2(0.5, 0.5))
	if TYPE == 'Circle':
		var node = preload("res://Scenes/Paths.tscn").instance()
		node.REFERENCE_NODE = self
		get_parent().call_deferred("add_child", node)

func _process(_delta):
	if TYPE != 'Square' and TYPE != 'Dot' and TYPE != 'Circle':
		if TYPE == 'Pentagon':
			if PENTAGON_STATE == 'null':
				PENTAGON_STATE = 'activated'
				MovePentagon()
			else:
				if abs(point[0] - global_position[0]) > 10 and abs(point[1] - global_position[1]) > 10:
					DIR = global_position.direction_to(point)
					rotation = global_position.angle_to_point(point) + deg2rad(-90)
					global_position += DIR*15
		else:
			if abs(point[0] - global_position[0]) < 8 and abs(point[1] - global_position[1]) < 8:
				point = Vector2(Global.RANDOM.randi_range(100, 700), Global.RANDOM.randi_range(100, 700))
		if point != global_position:
			DIR = global_position.direction_to(point)
			rotation = global_position.angle_to_point(point) + deg2rad(-90)
			match TYPE:
				'Diamond':
					global_position += DIR*2
				'Triangle':
					global_position += DIR*5
	if entered == true and index < 1:
		if TYPE == 'Dot':
			index = 1
		index += 0.002#demora +- 8 segundos para ficar cheio
		$FILL.set_modulate(Color(1, 1, 1, index))
		$FILL.visible = true
	if index >= 1:
		get_parent().POINTS_AREA_CONFIRMATIONS.append(self)
		if TYPE == 'Dot':
			$AnimationPlayer.play("RUN-DOT")
		else:
			$AnimationPlayer.play("RUN")
		$FILL2.visible = true
		set_process(false)

func MovePentagon() -> void:
	while index < 1:
		point = Vector2(Global.RANDOM.randi_range(100, 700), Global.RANDOM.randi_range(100, 700))
		$PentagonTimer.start()
		yield($PentagonTimer, "timeout")

func _on_Button_mouse_entered():
	entered = true

func _on_Button_mouse_exited():
	entered = false
