extends Node2D

var ENERGY = false

func _ready():
	Global.PLAYER_INFOS['actual_processor_cost'] += 0.25

func _on_Button_button_down():
	var last_pos = global_position
	while $Button.pressed:
		Global.DRAG_ITEM(self)
		if Input.is_action_pressed("Q"):
			Global.PLAYER_INFOS['actual_processor_cost'] -= 0.25
			self.queue_free()
		yield(get_tree().create_timer(0.02), "timeout")
	for z in get_tree().get_nodes_in_group("CABLE"):
		if z != self:
			if z.global_position == global_position:
				global_position = last_pos
