extends Node2D

func _ready():
	Global.set_process_bit(self, false)
	set_process(true)

func _process(_delta):
	if get_global_mouse_position()[0] > 0 and get_global_mouse_position()[0] < 800:
		if get_global_mouse_position()[1] > 0 and get_global_mouse_position()[1] < 800:
			global_position = get_global_mouse_position()

func _on_Area2D_area_entered(area):
	area = area.get_parent().get_parent()
	if area.is_in_group('ENEMY_PROJECTILE'):
		get_tree().paused = true
		get_tree().get_nodes_in_group("GAME")[0].find_node('RestarLevel').visible = true
