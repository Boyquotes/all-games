extends CharacterBody2D

var TYPE = 'commom'

var PATH = []

var ATTR = {
	'actual_health': 5,
	'max_health': 5,
	'stop': false,
	'char': false,
	'slow': false,
}

func _ready():
	for z in $Area2D.get_children():
		if z.get_name() != TYPE:
			z.free()
	if TYPE == 'fast':
		$ARMA.visible = false
	ATTR['max_health'] = Global.ENEMY_TYPES[TYPE][1]
	ATTR['actual_health'] = Global.ENEMY_TYPES[TYPE][1]
	$LIFEBAR.max_value = ATTR['max_health']
	$LIFEBAR.value = ATTR['max_health']
	$AnimatedSprite.play(TYPE+'-RUN')
	add_user_signal("HEALTH_CHANGED")
# warning-ignore:return_value_discarded
	connect("HEALTH_CHANGED", self, "_on_HEALTH_CHANGED_SIGNAL_EMMITED")
	add_user_signal("CHAR_ENTERED", ['chara'])
# warning-ignore:return_value_discarded
	connect("CHAR_ENTERED", self, "_on_CHAR_ENTERED")
	PATH = Global.levelNavigation.get_simple_path(global_position, Global.player.global_position, false)
	if TYPE == 'boss2':
		while self:
			Global.SPAWN($ARMA/POINTER.global_position, 'fast')
			await get_tree().create_timer(3).timeout

func _process(_delta):
	if len(PATH) > 0:
		if global_position != PATH[0]:
	# warning-ignore:return_value_discarded
			move_and_slide(global_position.direction_to(PATH[0])*Global.ENEMY_TYPES[TYPE][0])
		if global_position == PATH[0]:
			PATH.remove(0)

func _on_HEALTH_CHANGED_SIGNAL_EMMITED():
	if ATTR['actual_health'] <= 0:
		var random2 = randi()%100+1
		if random2 > 90:
			var a = randi()%3
			var node2 = preload("res://Scenes/DROPS.tscn").instance()
			node2.global_position = global_position
			var resultado = {
				'0': 'BULLETS',
				'1': 'LIFE',
				'2': 'POINTS',
			}
			node2.TYPE = resultado[str(a)]
			get_tree().get_nodes_in_group("MAIN_SCENE")[0].add_child(node2)
		queue_free()
	else:
		if ATTR['actual_health'] != ATTR['max_health']:
			find_node("LIFEBAR").visible = true
		find_node("LIFEBAR").value = ATTR['actual_health']

func _on_CHAR_ENTERED(chara):
	while ATTR['char'] == true:
		ATTR['stop'] = true
		chara.ATTR['actual_health'] -= Global.ENEMY_TYPES[TYPE][2] - (chara.ATTR['defense']*0.5)
		await get_tree().create_timer(1).timeout
		ATTR['stop'] = false

func _on_Area2D_body_entered(body):
	if body.is_in_group("CHAR"):
		ATTR['char'] = true
		body.ATTR['actual_health'] -= Global.ENEMY_TYPES[TYPE][2] - (body.ATTR['defense']*0.5)
		ATTR['stop'] = true
		await get_tree().create_timer(1).timeout
		emit_signal("CHAR_ENTERED", body)
		ATTR['stop'] = false

func _on_Area2D_body_exited(body):
	if body.is_in_group("CHAR"):
		ATTR['char'] = false

