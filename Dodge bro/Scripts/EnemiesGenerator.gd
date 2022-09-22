extends Node2D

export(int) var SPAWN_DELAY = 5
export(PackedScene) var ENEMY_TYPE = preload("res://Scenes/History/Enemies/HistoryEnemy.tscn")

var enemies_generated = 0

func _ready():
	$Timer.set_wait_time(SPAWN_DELAY)
	Global.set_process_bit(self, false)
	set_process(true)

func _process(_delta):
	if get_parent().player_in_scene == true:
		$Timer.start()
		set_process(false)

func _on_Timer_timeout():
	if enemies_generated < 11:
		var node = ENEMY_TYPE.instance()
		node.global_position = get_parent().get_child(0).get_child(1).get_child(0).global_position
		get_tree().get_root().call_deferred('add_child', node)
		$Timer.stop()
		set_process(true)
		enemies_generated += 1
