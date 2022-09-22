extends Node2D

var TYPE: String
var apply = true
var BODIES: Array

#TYPES: MOLOTOV(FIRE), (POISON), (SLOW), 

func _ready():
	$Timer.set_wait_time(Global.THROWABLE_INFOS[TYPE][2])
	$Timer.start()
	$AnimatedSprite.play(TYPE)
	while apply == true:
		for z in BODIES:
			if z != null and z.is_in_group("ENEMY"):
				if TYPE == 'MOLOTOV':
					z.ATTR['actual_health'] -= Global.THROWABLE_INFOS[TYPE][1] - (Global.ENEMY_TYPES[z.TYPE][3]*0.5)
				if TYPE == 'SLOW':
					z.ATTR['slow'] = true
				if TYPE == 'POISON':
					z.ATTR['slow'] = true
					z.ATTR['actual_health'] -= Global.THROWABLE_INFOS[TYPE][1] - (Global.ENEMY_TYPES[z.TYPE][3]*0.5)
		yield(get_tree().create_timer(0.25), "timeout")

func _on_Timer_timeout():
	apply = false
	$AnimationPlayer.play("RUN")

func _on_Area2D_body_entered(body):
	BODIES.append(body)

func _on_Area2D_body_exited(body):
	BODIES.remove(BODIES.find(body))

func _on_AnimationPlayer_animation_finished(_anim_name):
	for z in BODIES:
		z.ATTR['slow'] = false
	queue_free()


