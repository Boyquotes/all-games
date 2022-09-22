extends Node2D
var LIFE = 20
var direction = Vector2(cos(Global.RANDOM.randf_range(0, 1)), sin(Global.RANDOM.randf_range(0, 1)))

func _process(_delta):
	global_position += direction
	$Sprite.rotation_degrees += 0.5

func _on_Area2D_area_entered(area):
	area = area.get_parent()
	if area.is_in_group("PLAYER_PROJECTILE"):
		Global.play_sound('hit')
		LIFE -= area.DMG
		$Progress.value -= area.DMG
		$Progress.visible = true
		Global.ADD_DMG_LABEL(area.global_position, area.DMG)
		if area.DIE:
			area.find_node('Timer').stop()
			area.queue_free()
		if LIFE <= 0:
			Global.PLAYER_INFOS['exp']+=100
			queue_free()
