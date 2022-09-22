extends GridContainer

var TYPE: String

func _ready():
	var textures = {
		'KNIFE': "res://Images/THROWABLE/KNIFE.png",
		'MOLOTOV': "res://Images/THROWABLE/MOLOTOV.png",
		'GRENADE': "res://Images/THROWABLE/GRANADA.png",
		'SLOW': '',
		'POISON': '',
	}
	$TextureRect.texture = load(textures[TYPE])
