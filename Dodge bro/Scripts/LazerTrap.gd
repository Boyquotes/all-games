extends Node2D

export(bool) var VERTICAL = true
export(float) var ACTIVATION_DELAY = 3
export(float) var DURATION = 2

var DMG = 1
var DIE = false

func _ready():
	Global.set_process_bit(self, false)
	if VERTICAL == true:
		$"LEFT".queue_free()
		$"RIGHT".queue_free()
		$"HORIZONTAL".queue_free()
	else:
		$"UP".queue_free()
		$"DOWN".queue_free()
		$"VERTICAL".queue_free()
	while self:
		yield(get_tree().create_timer(ACTIVATION_DELAY-0.5), "timeout")
		if VERTICAL == true:
			$"UP/E_VERT".visible = true
		else:
			$"LEFT/E_HORI".visible = true
		yield(get_tree().create_timer(0.5), "timeout")
		if VERTICAL == true:
			$"VERTICAL".visible = true
			$"VERTICAL/CollisionShape2D".disabled = false
			$"UP/E_VERT".visible = false
		else:
			$"HORIZONTAL".visible = true
			$"HORIZONTAL/CollisionShape2D".disabled = false
			$"LEFT/E_HORI".visible = false
		yield(get_tree().create_timer(DURATION), "timeout")
		if VERTICAL == true:
			$"VERTICAL".visible = false
			$"VERTICAL/CollisionShape2D".disabled = true
		else:
			$"HORIZONTAL".visible = false
			$"HORIZONTAL/CollisionShape2D".disabled = true

