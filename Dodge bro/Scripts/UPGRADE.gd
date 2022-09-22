extends GridContainer
#['type in string', value, rarity, 'texture', 'description', 'card name']
var TYPE = []
var mega = false
func _ready():
	$IMG.texture = load(TYPE[3])
	$DESCRIPTION.text = TYPE[4]
	$NAME.text = TYPE[5]
	var cor
	match TYPE[2]:
		0:
			cor = Color(0, 1, 0.015686)
		1:
			cor = Color(0.881802, 0.90625, 0.123901)
		2:
			cor = Color(0.769531, 0.108215, 0)
	$IMG.set_modulate(cor)
	$UPGRADE.set_modulate(cor)

func _on_UPGRADE_button_up():
	if mega:
		get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().emit_signal("Upgrade_choosen", TYPE, true)
	else:
		get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().emit_signal("Upgrade_choosen", TYPE)
