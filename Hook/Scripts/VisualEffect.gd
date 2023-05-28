extends Node2D

enum TYPES {
	PLAYER_SLAM
}

export(TYPES) var TYPE

var effect: Node2D

func build_effect(type):
	var node
	match type:
		TYPES.PLAYER_SLAM:
			node = preload("res://Scenes/VisualEffects/PlayerSlamVisualEffect.tscn").instance()
	
	node.global_position = global_position
	call_deferred("add_child", node)
	effect = node

func _enter_tree():
	build_effect(TYPE)
	
	effect.play_anim()
