extends Node2D

var ENERGY = false
var POINTS = []
export var TYPE: String#'potencia_computacional_atual' || 'potencia_energetica_atual'

func _ready():
	if TYPE == 'potencia_computacional_atual':
		Global.PLAYER_INFOS[TYPE] += 1
	POINTS = Global.RETURN_POINTS(self)
	Global.PLAYER_INFOS['actual_processor_cost']+=Global.OBJ_INFO[str(len(POINTS))][4]
	set_process(false)

func _process(_delta):
	#if Input.is_action_just_pressed("R"):
	#	if self.rotation_degrees+90 == 360:
	#		self.rotation_degrees = 0
	#	else:
	#		self.rotation_degrees += 90
	if Input.is_action_pressed("Q") and TYPE == 'potencia_computacional_atual':
		Global.PLAYER_INFOS[TYPE] -= 1
		Global.PLAYER_INFOS['actual_processor_cost'] -= Global.OBJ_INFO[str(len(POINTS))][4]
		self.queue_free()

func _on_Button_button_down():
	set_process(true)
	var last_pos = global_position
	while $Button.pressed:
		Global.DRAG_ITEM(self)
		yield(get_tree().create_timer(0.02), "timeout")
	set_process(false)
	POINTS = Global.RETURN_POINTS(self)
	Global.ANALYSE_POSITION(self, last_pos)
	set_z_index(0)
