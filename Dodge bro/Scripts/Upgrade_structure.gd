extends GridContainer

var TYPE = ''
var value: int

func _ready():
	$Item.texture = load(Global.SHIP_UPGRADES[TYPE][3])
	set_this()

func set_this():
	value = Global.SHIP_UPGRADES[TYPE][2]*Global.SHIP_UPGRADES[TYPE][0]
	$Lvl.text = str(Global.SHIP_UPGRADES[TYPE][0])
	$Need.text = str(Global.PLAYER_INFOS['upgrade_parts'])+'/'+str(value)
	if Global.PLAYER_INFOS['upgrade_parts'] >= value:
		$Plus.disabled = false
	else:
		$Plus.disabled = true

func _on_Plus_button_up():
	Global.PLAYER_INFOS['upgrade_parts'] -= value
	Global.SHIP_UPGRADES[TYPE][0] += 1
	for z in get_tree().get_nodes_in_group('Upgrade_structure'):
		z.set_this()
