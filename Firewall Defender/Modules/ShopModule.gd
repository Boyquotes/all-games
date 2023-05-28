extends GridContainer

enum TYPES {
	UPGRADE_HEALTH,
	BUY_HEALTH,
	
	BUY_WALL,
	BUY_PREVENTION,
	BUY_ENCRYPTED,
	BUY_WANDERING,
	
	UPGRADE_SHIELD,
	UPGRADE_WALL,
	UPGRADE_PREVENTION,
	UPGRADE_ENCRYPTED,
	UPGRADE_WANDERING,
	
	BUY_MEGA_SHIELD,
	BUY_MEGA_WALL,
	BUY_MEGA_PREVENTION,
	BUY_MEGA_ENCRYPTED,
	BUY_MEGA_WANDERING,
	
	UPGRADE_ENERGY_PER_TICK,
	UPGRADE_MAX_ENERGY,
	
	BUY_HOURGLASS_POWER_UP,
	BUY_BOMB_POWER_UP
}

const TEXTURES = {
	TYPES.UPGRADE_HEALTH: "res://Images/ShopItems/life_up.png",
	TYPES.BUY_HEALTH: "res://Images/ShopItems/life_buy.png",
	
	TYPES.BUY_WALL: "res://Images/ShopItems/wall_buy.png",
	TYPES.BUY_PREVENTION: "res://Images/ShopItems/turret_buy.png",
	TYPES.BUY_ENCRYPTED: "res://Images/ShopItems/crypt_buy.png",
	TYPES.BUY_WANDERING: "res://Images/ShopItems/wandering_buy.png",
	
	TYPES.UPGRADE_SHIELD: "res://Images/ShopItems/shield_up.png",
	TYPES.UPGRADE_WALL: "res://Images/ShopItems/wall_up.png",
	TYPES.UPGRADE_PREVENTION: "res://Images/ShopItems/turret_up.png",
	TYPES.UPGRADE_ENCRYPTED: "res://Images/ShopItems/crypt_up.png",
	TYPES.UPGRADE_WANDERING: "res://Images/ShopItems/wandering_up.png",
	
	TYPES.BUY_MEGA_SHIELD: "res://Images/ShopItems/shield_mega.png",
	TYPES.BUY_MEGA_WALL: "res://Images/ShopItems/wall_mega.png",
	TYPES.BUY_MEGA_PREVENTION: "res://Images/ShopItems/turret_mega.png",
	TYPES.BUY_MEGA_ENCRYPTED: "res://Images/ShopItems/crypt_mega.png",
	TYPES.BUY_MEGA_WANDERING: "res://Images/ShopItems/wandering_mega.png",
	
	TYPES.UPGRADE_ENERGY_PER_TICK: "res://Images/ShopItems/energy_buy.png",
	TYPES.UPGRADE_MAX_ENERGY: "res://Images/ShopItems/energy_up.png",
	
	TYPES.BUY_HOURGLASS_POWER_UP: "res://Images/Icons/Hourglass.png",
	TYPES.BUY_BOMB_POWER_UP: "res://Images/Icons/Bomb.png",
}

var UPGRADE_BY_TYPE = {
	TYPES.UPGRADE_SHIELD: Global.HABILITIES.SHIELD,
	TYPES.UPGRADE_WALL: Global.HABILITIES.WALL,
	TYPES.UPGRADE_PREVENTION: Global.HABILITIES.PREVENTION,
	TYPES.UPGRADE_ENCRYPTED: Global.HABILITIES.ENCRYPTED_PIPE,
	TYPES.UPGRADE_WANDERING: Global.HABILITIES.WANDERING_FIREWALL,
	
	TYPES.UPGRADE_HEALTH: 'max_health',
	TYPES.UPGRADE_ENERGY_PER_TICK: 'energy_per_tick',
	TYPES.UPGRADE_MAX_ENERGY: 'max_energy',
}

const BUY_BY_TYPE = {
	TYPES.BUY_HEALTH: 'actual_health',
	
	TYPES.BUY_WALL: 'wall',
	TYPES.BUY_PREVENTION: 'prevention',
	TYPES.BUY_ENCRYPTED: 'encrypted_pipe',
	TYPES.BUY_WANDERING: 'wandering_firewall',
	
	TYPES.BUY_MEGA_SHIELD: 'mega_shield',
	TYPES.BUY_MEGA_WALL: 'mega_wall',
	TYPES.BUY_MEGA_PREVENTION: 'mega_prevention',
	TYPES.BUY_MEGA_ENCRYPTED: 'mega_encrypted_pipe',
	TYPES.BUY_MEGA_WANDERING: 'mega_wandering_firewall',
	
	TYPES.BUY_HOURGLASS_POWER_UP: 'hourglass_power_up',
	TYPES.BUY_BOMB_POWER_UP: 'bomb_power_up',
}

const BUY_TYPES = [
	TYPES.BUY_HEALTH,
	
	TYPES.BUY_WALL,
	TYPES.BUY_PREVENTION,
	TYPES.BUY_ENCRYPTED,
	TYPES.BUY_WANDERING,
	
	TYPES.BUY_MEGA_SHIELD,
	TYPES.BUY_MEGA_WALL,
	TYPES.BUY_MEGA_PREVENTION,
	TYPES.BUY_MEGA_ENCRYPTED,
	TYPES.BUY_MEGA_WANDERING,
	
	TYPES.BUY_HOURGLASS_POWER_UP,
	TYPES.BUY_BOMB_POWER_UP,
]

const UPGRADE_TYPES = [
	TYPES.UPGRADE_ENERGY_PER_TICK,
	TYPES.UPGRADE_MAX_ENERGY,
	TYPES.UPGRADE_HEALTH,
	
	TYPES.UPGRADE_SHIELD,
	TYPES.UPGRADE_WALL,
	TYPES.UPGRADE_PREVENTION,
	TYPES.UPGRADE_ENCRYPTED,
	TYPES.UPGRADE_WANDERING,
]

const HABILITIES_TYPES = [
	TYPES.UPGRADE_SHIELD,
	TYPES.UPGRADE_WALL,
	TYPES.UPGRADE_PREVENTION,
	TYPES.UPGRADE_ENCRYPTED,
	TYPES.UPGRADE_WANDERING,
]

onready var PRICE_LABEL = $GridContainer/Price

export(TYPES) var TYPE

var actual_price

onready var GAME = get_tree().get_nodes_in_group("GAME")[0]

func analyse_self_destruct():
	var parent = get_parent()
	
	parent.remove_child(self)
	
	if len(parent.get_children()) == 0:
		parent.queue_free()
	else:
		queue_free()

func evolve_type():
	match TYPE:
		TYPES.BUY_WALL:
			TYPE = TYPES.UPGRADE_WALL
		TYPES.BUY_PREVENTION:
			TYPE = TYPES.UPGRADE_PREVENTION
		TYPES.BUY_ENCRYPTED:
			TYPE = TYPES.UPGRADE_ENCRYPTED
		TYPES.BUY_WANDERING:
			TYPE = TYPES.UPGRADE_WANDERING
		
		TYPES.BUY_MEGA_ENCRYPTED:
			analyse_self_destruct()
		TYPES.BUY_MEGA_PREVENTION:
			analyse_self_destruct()
		TYPES.BUY_MEGA_SHIELD:
			analyse_self_destruct()
		TYPES.BUY_MEGA_WALL:
			analyse_self_destruct()
		TYPES.BUY_MEGA_WANDERING:
			analyse_self_destruct()
		
		TYPES.UPGRADE_SHIELD:
			TYPE = TYPES.BUY_MEGA_SHIELD
		TYPES.UPGRADE_WALL:
			TYPE = TYPES.BUY_MEGA_WALL
		TYPES.UPGRADE_PREVENTION:
			TYPE = TYPES.BUY_MEGA_PREVENTION
		TYPES.UPGRADE_ENCRYPTED:
			TYPE = TYPES.BUY_MEGA_ENCRYPTED
		TYPES.UPGRADE_WANDERING:
			TYPE = TYPES.BUY_MEGA_WANDERING
		
	update_infos()

func store_actual_price():
	var upgrade_values
	
	if TYPE in UPGRADE_TYPES:
		upgrade_values = Global.UPGRADES[UPGRADE_BY_TYPE[TYPE]]
		
		actual_price = upgrade_values[0] + (upgrade_values[1] * upgrade_values[2]) + Global.MONEY_BUFFER
	else:
		actual_price = Global.BUY_VALUES[BUY_BY_TYPE[TYPE]] + (Global.MONEY_BUFFER * 5)
	

func update_infos():
	store_actual_price()
	
	$Button.get_child(0).texture = load(TEXTURES[TYPE])
	PRICE_LABEL.text = str(actual_price)

func spent(amount):
	Global.PLAYER_INFOS['firewall_points'] -= amount

func can_spent():
	return Global.PLAYER_INFOS['firewall_points'] >= actual_price

func buy():
	if can_spent():
		spent(actual_price)
		
		if BUY_BY_TYPE[TYPE] in ['wall', 'prevention', 'encrypted_pipe', 'wandering_firewall']:
			Global.PLAYER_INFOS['habilities'].append(BUY_BY_TYPE[TYPE])
			GAME.show_hability(BUY_BY_TYPE[TYPE])
		elif BUY_BY_TYPE[TYPE] in ['actual_health']:
			Global.PLAYER_INFOS[BUY_BY_TYPE[TYPE]] += 1
			Global.hit_firewall(0)
		elif BUY_BY_TYPE[TYPE] in ['hourglass_power_up']:
			Engine.time_scale = 0.5
			Global.musics.set_pitch_scale(Global.musics.get_pitch_scale()/2)
			Global.sounds.set_pitch_scale(Global.sounds.get_pitch_scale()/2)
			yield(get_tree().create_timer(5), "timeout")
			Global.musics.set_pitch_scale(Global.musics.get_pitch_scale()*2)
			Global.sounds.set_pitch_scale(Global.sounds.get_pitch_scale()*2)
			Engine.time_scale = 1
		elif BUY_BY_TYPE[TYPE] in ['bomb_power_up']:
			for z in get_tree().get_nodes_in_group("ENEMY"):
				z.queue_free()
			Global.bombed = true
			yield(get_tree().create_timer(5), "timeout")
			Global.bombed = false
		else:
			Global.PLAYER_INFOS['mega_habilities'].append(BUY_BY_TYPE[TYPE])
		
		evolve_type()

const INCREMENT_VALUE_BY_UPGRADE_VALUE = {
	'max_health': 1,
	'energy_per_tick': 0.25,
	'max_energy': 1
}

func upgrade():
	if can_spent():
		spent(actual_price)
		
		if UPGRADE_BY_TYPE[TYPE] in ['max_health', 'energy_per_tick', 'max_energy']:
			Global.PLAYER_INFOS[UPGRADE_BY_TYPE[TYPE]] += INCREMENT_VALUE_BY_UPGRADE_VALUE[UPGRADE_BY_TYPE[TYPE]]
			Global.hit_firewall(0)
			# TODO update max_health and max_energy
		else:
			Global.UPGRADES[UPGRADE_BY_TYPE[TYPE]][2] += 1
			Global.HABILITIES_COST[UPGRADE_BY_TYPE[TYPE]] += 1
			GAME.setup_habilities_cost()
		
		if Global.UPGRADES[UPGRADE_BY_TYPE[TYPE]][2] == 5:
			evolve_type()

func _ready():
	store_actual_price()
	update_infos()

func is_maxed():
	if TYPE in HABILITIES_TYPES:
		return Global.UPGRADES[UPGRADE_BY_TYPE[TYPE]][2] == 5
	else:
		return false

func _process(_delta):
	$Button.disabled = !(Global.PLAYER_INFOS['firewall_points'] >= actual_price) or is_maxed() or TYPE in BUY_TYPES and BUY_BY_TYPE[TYPE] in ['actual_health'] and Global.PLAYER_INFOS['actual_health'] == Global.PLAYER_INFOS['max_health'] or TYPE == TYPES.BUY_HOURGLASS_POWER_UP and Engine.time_scale == 0.5 or TYPE == TYPES.BUY_BOMB_POWER_UP and Global.bombed == true


func _on_Button_button_up():
	var already = false
	
	if TYPE in UPGRADE_TYPES and !already:
		if !(UPGRADE_BY_TYPE[TYPE] in ['max_health', 'energy_per_tick', 'max_energy']):
			Global.show_tutorial('up_'+Global.NAME_BY_HABILITY[UPGRADE_BY_TYPE[TYPE]])
		upgrade()
		
		already = true
	
	if TYPE in BUY_TYPES and !already:
		if BUY_BY_TYPE[TYPE] in ['mega_shield', 'mega_wall', 'mega_prevention', 'mega_encrypted_pipe', 'mega_wandering_firewall']:
			Global.show_tutorial(BUY_BY_TYPE[TYPE])
		buy()
		
		already = true
	update_infos()
	Global.play_sound('button_pressed')


func _on_Button_mouse_entered():
	if TYPE in UPGRADE_TYPES:
		if TYPE in HABILITIES_TYPES:
			var CONVERSION_MAP = {
				Global.HABILITIES.SHIELD: 'up_shield',
				Global.HABILITIES.WALL: 'up_wall',
				Global.HABILITIES.PREVENTION: 'up_prevention',
				Global.HABILITIES.ENCRYPTED_PIPE: 'up_encrypted_pipe',
				Global.HABILITIES.WANDERING_FIREWALL: 'up_wandering_firewall',
			}
			GAME.show_info(CONVERSION_MAP[UPGRADE_BY_TYPE[TYPE]])
		else:
			GAME.show_info(UPGRADE_BY_TYPE[TYPE])
	else:
		GAME.show_info(BUY_BY_TYPE[TYPE])

func _on_Button_mouse_exited():
	GAME.reset_info()
