extends GridContainer

var TYPE: String
var OBJ: Array

func _ready():
	if TYPE == 'item':
		$TextureRect.texture = load(Global.TEXTURES[OBJ[0]])
		for _z in range(0, OBJ[1]):
			var node = TextureRect.new()
			node.set_custom_minimum_size(Vector2(15, 15))
			node.set_expand(true)
			node.texture = load("res://Images/ICONES_DE_JOGABILIDADE/ESTRELA.png")#estrela
			$GridContainer.add_child(node)
	if TYPE == 'worker':
		$TextureRect.texture = load(OBJ[1])

func _on_TextureButton_button_up():
	if TYPE == 'item':
		get_tree().get_nodes_in_group("GAME")[0].emit_signal("SET_RICH_OBJ_VIEW", OBJ)
	if TYPE == 'worker':
		get_parent().get_parent().get_parent().get_parent().visible = false
		get_tree().get_nodes_in_group("GAME")[0].emit_signal("SET_WORKER_VIEW", OBJ)
