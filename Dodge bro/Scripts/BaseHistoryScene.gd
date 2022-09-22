extends Node2D

export(bool) var UP = false
export(bool) var DOWN = false
export(bool) var RIGHT = false
export(bool) var LEFT = false

var PLAYER = false

func _ready():
	add_user_signal('NO_ENEMIES_IN_SCENE', ['type'])
# warning-ignore:return_value_discarded
	connect('NO_ENEMIES_IN_SCENE', self, "_on_NO_ENEMIES_IN_SCENE_SIGNAL_EMMITED")
	ANALYSE()

func ANALYSE():
	if UP:
		if LEFT:
			$"UP-LEFT".visible = true
		else:
			$"UP-LEFT".visible = false
		if RIGHT:
			$"UP-RIGHT".visible = true
		else:
			$"UP-RIGHT".visible = false
		$UP.visible = true
		$UP/Block.find_node("CollisionShape2D").set_deferred('disabled', false)
	else:
		$"UP-LEFT".visible = false
		$"UP-RIGHT".visible = false
		$UP/Block.find_node("CollisionShape2D").set_deferred('disabled', true)
		$UP.visible = false
	if DOWN:
		if LEFT:
			$"DOWN-LEFT".visible = true
		else:
			$"DOWN-LEFT".visible = false
		if RIGHT:
			$"DOWN-RIGHT".visible = true
		else:
			$"DOWN-RIGHT".visible = false
		$DOWN/Block.find_node("CollisionShape2D").set_deferred('disabled', false)
		$DOWN.visible = true
	else:
		$"DOWN-LEFT".visible = false
		$"DOWN-RIGHT".visible = false
		$DOWN/Block.find_node("CollisionShape2D").set_deferred('disabled', true)
		$DOWN.visible = false
	if RIGHT:
		$RIGHT.visible = true
		$RIGHT/Block.find_node("CollisionShape2D").set_deferred('disabled', false)
	else:
		$RIGHT/Block.find_node("CollisionShape2D").set_deferred('disabled', true)
		$RIGHT.visible = false
	if LEFT:
		$LEFT.visible = true
		$LEFT/Block.find_node("CollisionShape2D").set_deferred('disabled', false)
	else:
		$LEFT/Block.find_node("CollisionShape2D").set_deferred('disabled', true)
		$LEFT.visible = false

func _on_NO_ENEMIES_IN_SCENE_SIGNAL_EMMITED(type):
	match type:
		'start':
			if !UP:
				$ARROW_UP.visible = true
			if !DOWN:
				$ARROW_DOWN.visible = true
			if !RIGHT:
				$ARROW_RIGHT.visible = true
			if !LEFT:
				$ARROW_LEFT.visible = true
			$AnimationPlayer.play("Idle")
			ANALYSE()
		'stop':
			if PLAYER == false:
				get_tree().get_nodes_in_group("PLAYER")[0].global_position += get_tree().get_nodes_in_group("PLAYER")[0].global_position.direction_to(global_position)*55
				PLAYER = true
			$ARROW_UP.visible = false
			$ARROW_DOWN.visible = false
			$ARROW_RIGHT.visible = false
			$ARROW_LEFT.visible = false
			$AnimationPlayer.stop()
			
			$"UP".visible = true
			$"DOWN".visible = true
			$"LEFT".visible = true
			$"RIGHT".visible = true
			$"UP-LEFT".visible = true
			$"UP-RIGHT".visible = true
			$"DOWN-RIGHT".visible = true
			$"DOWN-LEFT".visible = true
			
			$LEFT/Block.find_node("CollisionShape2D").set_deferred('disabled', false)
			$RIGHT/Block.find_node("CollisionShape2D").set_deferred('disabled', false)
			$DOWN/Block.find_node("CollisionShape2D").set_deferred('disabled', false)
			$UP/Block.find_node("CollisionShape2D").set_deferred('disabled', false)
