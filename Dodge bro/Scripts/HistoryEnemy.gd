extends Node2D

#[nome do tipo, DMG, shoot delay, bulletspeed, speed, LIFE, projectile dies?, 'scene', 'bullet_scene' ...]
var INFOS = {
	'max_health': 20,
	'actual_health': 20,
}
var last_pos = Vector2.ZERO
onready var PLAYER = get_tree().get_nodes_in_group("PLAYER")[0]
var position_index = null

var shoot = false
var player_in_scene = false
func _enter_tree():
	run()

func run():
	$Progress.max_value = INFOS['max_health']
	$Progress.value =INFOS['max_health']
	$Sprite/Area2D.set_deferred('monitoring', true)
	set_deferred('visible', true)
	Global.set_process_bit(self, true)
	$Progress.visible = false

func _process(_delta):
	if player_in_scene == true:
		$Sprite/Gun.look_at(PLAYER.global_position)
		if shoot == true:
			Global.play_sound('shoot')
			var node = preload("res://Scenes/Enemies_projectiles/EnemyProjectile.tscn").instance()
			node.global_position = $Sprite/Gun/POINT.global_position
			node.rotation_degrees = $Sprite/Gun.rotation_degrees
			node.DMG = 1
			node.DIE = true
			node.set_linear_velocity(Vector2(480, 0).rotated($Sprite/Gun.rotation))
			get_tree().get_root().call_deferred("add_child", node)
			shoot = false
			$Timer.start()
	var Y = global_position[1] - last_pos[1]
	var X = global_position[0] - last_pos[0]
	if Y < 0: Y*=-1
	if X < 0: X*=-1
	if X >= 16 or Y >= 16:
		last_pos = global_position
		for z in $Sprite/PARTICLES_HANDLER.get_children():
			var particle = preload("res://Scenes/Particle.tscn").instance()
			particle.position = z.global_position
			particle.rotation_degrees = $Sprite.rotation_degrees
			get_tree().get_root().add_child(particle)
	if position_index == null:
		if global_position.distance_to(get_tree().get_nodes_in_group("PLAYER")[0].global_position) > 350:
			global_position += global_position.direction_to(get_tree().get_nodes_in_group("PLAYER")[0].global_position)*200
	else:
		var point = Vector2(cos(position_index)*350+PLAYER.global_position[0], sin(position_index)*350+PLAYER.global_position[1])
		global_position += global_position.direction_to(point)*200
	$Sprite.look_at(get_tree().get_nodes_in_group("PLAYER")[0].global_position)

func _on_Area2D_area_entered(area):
	area = area.get_parent()
	if area.is_in_group("PLAYER_PROJECTILE"):
		Global.play_sound('hit')
		$Progress.visible = true
		$Progress.value -= area.DMG
		Global.ADD_DMG_LABEL(area.global_position, area.DMG)
		if area.DIE:
			#area.BACK_TO_POOL()
			area.queue_free()
		if $Progress.value <= 0:
			Global.EXPLODE(global_position)
			queue_free()

func _on_Timer_timeout():
	shoot = true
	$Timer.stop()
