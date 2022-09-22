extends Area2D

onready var PLAYER = get_tree().get_nodes_in_group("PLAYER")[0]

var PLAYER_HERE = false

var ENEMIES_LIST = []

func _ready():
	set_process_bit(self, false)
	for z in get_tree().get_nodes_in_group("ENEMY"):
		if z.global_position[0]>global_position[0]-683 and z.global_position[0]<global_position[0]+683 and z.global_position[1]>global_position[1]-384 and z.global_position[1]<global_position[1]+384:
			ENEMIES_LIST.append(z)
			z.ORIGIN_NODE = self

func set_process_bit(obj, value):
	obj.set_process(value)
	obj.set_physics_process(value)
	obj.set_process_input(value)
	obj.set_process_internal(value)
	obj.set_process_unhandled_input(value)
	obj.set_process_unhandled_key_input(value)

func ANALYSE():
	var enemies_in_scene = 0
	if PLAYER_HERE == true:
		for z in ENEMIES_LIST:
			z.player_in_scene = true
			enemies_in_scene += 1
	else:
		for z in ENEMIES_LIST:
			z.player_in_scene = false
	if enemies_in_scene == 0:
		get_parent().emit_signal("NO_ENEMIES_IN_SCENE", 'start')
	else:
		get_parent().emit_signal("NO_ENEMIES_IN_SCENE", 'stop')

func _on_CameraHandler_area_entered(area):
	area = area.get_parent()
	if area.is_in_group("PLAYER"):
		PLAYER_HERE = true
		ANALYSE()
		
		get_tree().get_nodes_in_group("INTERESTELLAR_INFOS")[0].need_to_move = true
		get_tree().get_nodes_in_group("INTERESTELLAR_INFOS")[0].posi = global_position
		
	if area.is_in_group("ENEMY"):
		ANALYSE()


func _on_CameraHandler_body_exited(body):
	if body.is_in_group("PLAYER"):
		PLAYER_HERE = false
		ANALYSE()
