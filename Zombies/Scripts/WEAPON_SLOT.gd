extends GridContainer

var SLOT = {
	'name': '',
	'shoot_type': '',
	'img': '',
	'DMG': 0,
	'fire_rate': 0,#se for automática colocar um valor maior que 0
	'bullets': 0,
	'bullet_speed': 0,
	'pent_bullets': 0,
	'reload': 0,
	'reload_need': 0,#em segundos
	'weight': 0,
}

func GO(weapon):
	for z in ['name', 'shoot_type', 'img']:
		SLOT[z] = ''
		SLOT[z] += Global.WEAPON_INFOS[weapon][z]
	for z in ['DMG', 'fire_rate', 'bullets', 'bullet_speed', 'pent_bullets', 'reload', 'reload_need', 'weight']:
		SLOT[z] = 0
		SLOT[z] += Global.WEAPON_INFOS[weapon][z]
	
	$TextureRect.texture = load(SLOT['img'])
	$Label.text = SLOT['name']
