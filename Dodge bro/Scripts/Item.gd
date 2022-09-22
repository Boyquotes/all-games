extends Node2D
var TYPE = ''
var power_up = false
const TEXTURES = {
	'upgrade_parts': ["res://Images/ITEMS/Upgrade_parts.png", 'Upgrade Parts'],
	
	'power_up_speed': ["res://Images/ITEMS/Speed_power_up.png", '+SPEED'],
	'power_up_bullet_dmg': ["res://Images/ITEMS/DMG_power_up.png", '+BULLET DMG'],
	'power_up_special_bullet': ["res://Images/ITEMS/SPECIAL_BULLET_power_up.png", 'SPECIAL BULLET'],
	'power_up_shoot_delay': ["res://Images/ITEMS/SHOOT_DELAY_power_up.png", '+SHOOT SPEED'],
	'power_up_kill_all_enemies': ["res://Images/ITEMS/KILL_ALL_ENEMIES_power_up.png", 'KILL ALL ENEMIES'],
}

func _ready():
	$Sprite.texture = load(TEXTURES[TYPE][0])
