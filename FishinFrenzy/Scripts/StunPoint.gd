extends Node2D

func _ready():
	Global.set_process_bit(self, false)
	$AnimationPlayer.play("Run")
	set_process(true)

func _process(_delta):
	if get_global_mouse_position().distance_to(global_position) <= 18 and $AnimationPlayer.is_playing() == true:
		$AnimationPlayer.play("Hit")
		get_parent().get_node("Fish").addStun(Player.INFOS['Hook'][1]*10)
		set_process(false)


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
