extends Area2D

onready var PLAYER = get_tree().get_nodes_in_group("PLAYER")[0]

func _ready():
	Global.set_process_bit(self, false)

func ANALYSE():
	var enemies_in_scene = 0
	if PLAYER.global_position[0]>global_position[0]-683 and PLAYER.global_position[0]<global_position[0]+683 and PLAYER.global_position[1]>global_position[1]-384 and PLAYER.global_position[1]<global_position[1]+384:
		for z in get_tree().get_nodes_in_group("ENEMY"):
			if z.global_position[0]>global_position[0]-683 and z.global_position[0]<global_position[0]+683 and z.global_position[1]>global_position[1]-384 and z.global_position[1]<global_position[1]+384:
				z.player_in_scene = true
				enemies_in_scene += 1
	if enemies_in_scene == 0:
		get_parent().emit_signal("NO_ENEMIES_IN_SCENE", 'start')
	else:
		get_parent().emit_signal("NO_ENEMIES_IN_SCENE", 'stop')


func _on_CameraHandler_body_entered(body):
	if body.is_in_group("PLAYER"):
		ANALYSE()
		#get_tree().get_nodes_in_group("INTERESTELLAR_INFOS")[0].global_position = global_position
		get_tree().get_nodes_in_group("INTERESTELLAR_INFOS")[0].need_to_move = true
		get_tree().get_nodes_in_group("INTERESTELLAR_INFOS")[0].posi = global_position
		for z in get_tree().get_nodes_in_group("ENEMY"):
			if z.global_position[0]>global_position[0]-683 and z.global_position[0]<global_position[0]+683 and z.global_position[1]>global_position[1]-384 and z.global_position[1]<global_position[1]+384:
				z.player_in_scene = true
	if body.is_in_group("ENEMY"):
		ANALYSE()


func _on_CameraHandler_body_exited(body):
	if body.is_in_group("PLAYER"):
		for z in get_tree().get_nodes_in_group("ENEMY"):
			if z.global_position[0]>global_position[0]-683 and z.global_position[0]<global_position[0]+683 and z.global_position[1]>global_position[1]-384 and z.global_position[1]<global_position[1]+384:
				z.player_in_scene = false
			get_parent().emit_signal("NO_ENEMIES_IN_SCENE", 'stop')
	if body.is_in_group("ENEMY"):
		ANALYSE()
