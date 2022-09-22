extends Node2D

export(bool) var UP = false
export(bool) var DOWN = false
export(bool) var RIGHT = false
export(bool) var LEFT = false

func _ready():
	add_user_signal('NO_ENEMIES_IN_SCENE', ['type'])
# warning-ignore:return_value_discarded
	connect('NO_ENEMIES_IN_SCENE', self, "_on_NO_ENEMIES_IN_SCENE_SIGNAL_EMMITED")
	if UP:
		if LEFT:
			$"UP-LEFT".visible = true
		if RIGHT:
			$"UP-RIGHT".visible = true
		$UP.visible = true
		$UP/Block.find_node("CollisionShape2D").disabled = false
	if DOWN:
		if LEFT:
			$"DOWN-LEFT".visible = true
		if RIGHT:
			$"DOWN-RIGHT".visible = true
		$DOWN/Block.find_node("CollisionShape2D").disabled = false
		$DOWN.visible = true
	if RIGHT:
		$RIGHT.visible = true
		$RIGHT/Block.find_node("CollisionShape2D").disabled = false
	if LEFT:
		$LEFT.visible = true
		$LEFT/Block.find_node("CollisionShape2D").disabled = false

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
		'stop':
			$ARROW_UP.visible = false
			$ARROW_DOWN.visible = false
			$ARROW_RIGHT.visible = false
			$ARROW_LEFT.visible = false
			$AnimationPlayer.stop()
