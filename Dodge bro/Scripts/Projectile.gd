extends RigidBody2D

var DMG
var DIE
var TYPE

func _ready():
	Global.set_process_bit(self, false)
	var value = 8
	if self.is_in_group("PLAYER_PROJECTILE"):
		value = Global.PLAYER_INFOS['bullet_distance']
	$Timer.set_wait_time(value)
	$Timer.start()

func _on_Timer_timeout():
	queue_free()

func _on_Area2D_body_entered(body):
	body = body.get_parent()
	if body.is_in_group("WALL"):
		queue_free()
