extends AnimatedSprite

var TYPE: String
var collision

#TYPES: BLOOD = KNIFE(for zombies getting hurt), GRENADE, MOLOTOV

func _ready():
	var collisions = {
		'GRENADE': $GRENADE/CollisionShape2D,
		'MOLOTOV': $MOLOTOV/CollisionShape2D,
		'KNIFE': null,
	}
	collision = collisions[TYPE]
	if collision != null:
		collision.disabled = false
	if TYPE == 'GRENADE':
		play("GRENADE")
	if TYPE == 'MOLOTOV':
		play("MOLOTOV")
		var node = preload("res://Scenes/GROUND_EFFECT.tscn").instance()
		node.TYPE = 'MOLOTOV'
		node.global_position = global_position
		get_tree().get_nodes_in_group("MAIN_SCENE")[0].add_child(node)

func _on_Explosion_animation_finished():
	queue_free()

func _on_GRENADE_body_entered(body):
	if body.is_in_group("ENEMY"):
		body.ATTR['actual_health'] -= Global.THROWABLE_INFOS[TYPE][0] - (Global.ENEMY_TYPES[body.TYPE][3]*0.5)
		body.emit_signal('HEALTH_CHANGED')

func _on_MOLOTOV_body_entered(body):
	if body.is_in_group("ENEMY"):
		body.ATTR['actual_health'] -= Global.THROWABLE_INFOS[TYPE][0] - (Global.ENEMY_TYPES[body.TYPE][3]*0.5)
		body.emit_signal('HEALTH_CHANGED')
