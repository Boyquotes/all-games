extends Sprite

export(bool) var TurretArea = true

var TYPE = '5'

const TILES = {
	'0': Rect2(0, 0, 16, 16),
	'1': Rect2(16, 0, 16, 16),
	'2': Rect2(32, 0, 16, 16),
	'3': Rect2(48, 0, 16, 16),
	'4': Rect2(0, 16, 16, 16),
	'5': Rect2(16, 16, 16, 16),
	'6': Rect2(32, 16, 16, 16),
	'7': Rect2(48, 16, 16, 16),
	'8': Rect2(0, 32, 16, 16),
	'9': Rect2(16, 32, 16, 16),
	'10': Rect2(32, 32, 16, 16),
	'11': Rect2(48, 32, 16, 16),
	'12': Rect2(0, 48, 16, 16),
	'13': Rect2(16, 48, 16, 16),
	'14': Rect2(32, 48, 16, 16),
	'15': Rect2(48, 48, 16, 16),
}

func _enter_tree():
	#TYPE = str(Global.RAND.randi_range(0, len(TILES)-1))
	set_region_rect(TILES[TYPE])
	#if int(TYPE) < 12:
	#	get_parent().get_parent().GenerateTile(TYPE, global_position)
	
