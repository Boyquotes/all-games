extends RigidBody2D

var DMG: float

func _on_Area2D_body_entered(body):
	if body.is_in_group("GROUND"):
		queue_free()
	if body.is_in_group("ENEMY") and is_in_group("PLAYER_PROJECTILE"):
		body.HP -= DMG
		queue_free()
	if body.is_in_group("PLAYER") and is_in_group("ENEMY_PROJECTILE"):
		body.take_dmg(DMG)
		queue_free()
