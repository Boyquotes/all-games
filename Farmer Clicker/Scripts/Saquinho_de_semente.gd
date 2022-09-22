extends GridContainer

var TYPE

func _ready():
	$TextureRect.texture = load(Global.TEXTURES['semente_de_'+TYPE[0]])
	$GridContainer/GridContainer/Label2.text = str(TYPE[2])
	for _z in range(0, TYPE[1]):
		var node = TextureRect.new()
		node.set_custom_minimum_size(Vector2(40, 40))
		node.set_expand(true)
		node.texture = load("res://Images/ICONES_DE_JOGABILIDADE/ESTRELA.png")#estrela
		$GridContainer/GridContainer2/GridContainer.add_child(node)
