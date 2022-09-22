extends KinematicBody2D

var INFOS = {
	'actual_health': 10,
	'max_health': 10,
	'speed': 75,
	'dmg': 1,
}

enum STATES {
	WALK = 0,
	ATTACK = 1,
	KNOCKBACK = 2,
	YIELD = 3,
}

var actual_state = STATES.WALK
onready var PLAYER = get_tree().get_nodes_in_group('PLAYER')[0]
var POINT = Vector2.ZERO
var player_in_scene = false
var can_fire = true

func _process(_delta):
	if player_in_scene == true:
		if actual_state == STATES.WALK:
	# warning-ignore:return_value_discarded
			move_and_slide(global_position.direction_to(PLAYER.global_position)*INFOS['speed'])
		
		if actual_state == STATES.KNOCKBACK:
	# warning-ignore:return_value_discarded
			move_and_slide(global_position.direction_to(POINT)*-350)
		
		if INFOS['actual_health'] <= 0:
			queue_free()
		
		$HOLDER.rotation = lerp($HOLDER.rotation, get_angle_to(PLAYER.global_position) + deg2rad(90), 0.1)
		if $HOLDER.rotation <= deg2rad(135) and $HOLDER.rotation > deg2rad(45):
			$Sprite.texture = load("res://Animations/Idle/PlayerRight.png")
		elif $HOLDER.rotation <= deg2rad(45) and $HOLDER.rotation > deg2rad(-45):
			$Sprite.texture = load("res://Animations/Idle/PlayerUp.png")
		elif $HOLDER.rotation <= deg2rad(225) and $HOLDER.rotation > deg2rad(135):
			$Sprite.texture = load("res://Animations/Idle/PlayerDown.png")
		else:
			$Sprite.texture = load("res://Animations/Idle/PlayerLeft.png")
		
		if global_position.distance_to(PLAYER.global_position) <= 40 and can_fire == true:
			can_fire = false
			actual_state = STATES.ATTACK
			$AnimationPlayer.play("Sword_Attack")
			$"6".start()
			yield($"6", "timeout")
			$HOLDER/SWORD_ATK/Collision.disabled = false
			$"1".start()
			yield($"1", "timeout")
			$HOLDER/SWORD_ATK/Collision.disabled = true
			$AnimationPlayer.play("Sword_recovery")
			$Recover.start()
			yield($AnimationPlayer, "animation_finished")
			can_fire = true
		


func _on_Recover_timeout():
	actual_state = STATES.YIELD
	$Recover.stop()
	$YIELD.start()


func _on_YIELD_timeout():
	actual_state = STATES.WALK
	$YIELD.stop()


func _on_SWORD_ATK_body_entered(body):
	if body.is_in_group("PLAYER"):
		body.INFOS['actual_health'] -= INFOS['dmg']
