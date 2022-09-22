extends Sprite

var TYPE: String

#TYPES = BULLETS, LIFE

func _ready():
	if TYPE == 'BULLETS':
		set_texture(load("res://Images/DROPS/BULLETS.png"))
	if TYPE == 'LIFE':
		set_texture(load("res://Images/DROPS/LIFE.png"))
	if TYPE == 'POINTS':
		set_texture(load("res://Images/DROPS/POINTS.png"))

func _on_Area2D_body_entered(body):
	if body.is_in_group("CHAR"):
		var node = preload("res://Scenes/DROP_INFO.tscn").instance()
		if TYPE == 'BULLETS':
			node.text = 'AMMO+'
			body.find_node("Camera2D").find_node("GUI").find_node("GridContainer").get_child(body.ATTR['actual_weapon']).SLOT['bullets'] += body.find_node("Camera2D").find_node("GUI").find_node("GridContainer").get_child(body.ATTR['actual_weapon']).SLOT['reload']
		if TYPE == 'LIFE':
			node.text = 'HEALTH+'
			body.ATTR['actual_health'] += body.ATTR['health_regen']
		if TYPE == 'POINTS':
			node.text = 'POINTS+'
			body.ATTR['points'] += 10
		node.set_global_position(global_position)
		get_tree().get_nodes_in_group("MAIN_SCENE")[0].add_child(node)
		queue_free()
