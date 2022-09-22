extends GridContainer

var ITEM = ['coisa a ser melhorada']

func _ready():
	$TextureRect.texture = load(Global.TEXTURES[ITEM[0]])
	for _z in range(0, Global.INVENTORY[ITEM[0]]):
		var node = TextureRect.new()
		node.set_custom_minimum_size(Vector2(30, 30))
		node.set_expand(true)
		node.texture = preload("res://Images/ICONES_DE_JOGABILIDADE/ESTRELA.png")#estrela
		$GridContainer.add_child(node)

func _process(_delta):
	$GridContainer2/Label.text = str(Global.BASE_PRICES[ITEM[0]+'-'+str(Global.INVENTORY[ITEM[0]])]*Global.INVENTORY[ITEM[0]] + Global.BASE_PRICES[ITEM[0]+'-'+str(Global.INVENTORY[ITEM[0]])])

func _on_UPGRADE_button_up():
	Global.INVENTORY[ITEM[0]] += 1
	Global.INVENTORY['money'] -= int($GridContainer2/Label.text)
	var node = TextureRect.new()
	node.set_custom_minimum_size(Vector2(30, 30))
	node.set_expand(true)
	node.texture = preload("res://Images/ICONES_DE_JOGABILIDADE/ESTRELA.png")#estrela
	$GridContainer.add_child(node)
