extends GridContainer

var SCENE: String
onready var NODES = [$ACT/DECISION,$ACT/BATTLE,$ACT/SHRINE,$ACT/SHOP,$ACT/WEAPON_SHOP,$ACT/ARMOR_SHOP,$ACT/ACCESSORIES_SHOP,$ACT/CONSUMABLES_SHOP]
var infos = []

func ANALYSE():
	match SCENE:
		'DECISION':# = ["ACT/DECISION, [1, 1, 1], ['next possibles scenes types']]
			var possibilities = [
				[1, 1, 1],
				[1, 0, 0],
				[0, 1, 0],
				[0, 0, 1],
				[1, 1, 0],
				[1, 0, 1],
				[0, 1, 1],
			]#100% aleatório
			var random
			for _z in randi()%len(possibilities):
				random = randi()%len(possibilities)
			random = possibilities[random]
			for z in random:
				if random[z] == 1:
					$ACT/DECISION.get_children()[z].disabled = false
				else:
					$ACT/DECISION.get_children()[z].disabled = true
			
			infos.append($ACT/DECISION)
			infos.append(random)
			infos.append(RETURN_SCENES('DECISION'))#next possibles types
			
		'BATTLE':
			infos.append($ACT/BATTLE)
			infos.append(1)
			infos.append(RETURN_SCENES('BATTLE'))
		'LOOT':
			infos.append($ACT/LOOT)
			infos.append(1)
			infos.append(RETURN_SCENES('LOOT'))
		'SHRINE':
			infos.append($ACT/SHRINE)
			infos.append(1)
			infos.append(RETURN_SCENES('SHRINE'))
		'SHOP':
			infos.append($ACT/SHOP)
			infos.append(1)
			infos.append(RETURN_SCENES('SHOP'))
		'WEAPON_SHOP':
			infos.append($ACT/WEAPON_SHOP)
			infos.append(1)
			infos.append(RETURN_SCENES('WEAPON_SHOP'))
		'ARMOR_SHOP':
			infos.append($ACT/ARMOR_SHOP)
			infos.append(1)
			infos.append(RETURN_SCENES('ARMOR_SHOP'))
		'ACCESSORIES_SHOP':
			infos.append($ACT/ACCESSORIES_SHOP)
			infos.append(1)
			infos.append(RETURN_SCENES('ACCESSORIES_SHOP'))
		'CONSUMABLES_SHOP':
			infos.append($ACT/CONSUMABLES_SHOP)
			infos.append(1)
			infos.append(RETURN_SCENES('CONSUMABLES_SHOP'))
	for z in NODES:
		if z != infos[0]:
			z.visible = false
		else:
			z.visible = true


func RETURN_SCENES(TYPE):
	var scenes = []
	var possi = []
	for z in Global.SCENES_TYPES:
		if z != TYPE:
			possi.append(z)
	while len(scenes) < 3:
		var a = possi[randi()%len(possi)]
		scenes.append(a)
		possi.remove(possi.find(a))
	return scenes
