extends GridContainer

var TEXTURES = {
	Enums.SHOP_TYPES.UPGRADE_HEALTH: "res://Images/ShopItems/life_up.png",
	Enums.SHOP_TYPES.BUY_HEALTH: "res://Images/ShopItems/life_buy.png",
	
	Enums.SHOP_TYPES.BUY_WALL: "res://Images/ShopItems/wall_buy.png",
	Enums.SHOP_TYPES.BUY_PREVENTION: "res://Images/ShopItems/turret_buy.png",
	Enums.SHOP_TYPES.BUY_ENCRYPTED: "res://Images/ShopItems/crypt_buy.png",
	Enums.SHOP_TYPES.BUY_WANDERING: "res://Images/ShopItems/wandering_buy.png",
	
	Enums.SHOP_TYPES.UPGRADE_SHIELD: "res://Images/ShopItems/shield_up.png",
	Enums.SHOP_TYPES.UPGRADE_WALL: "res://Images/ShopItems/wall_up.png",
	Enums.SHOP_TYPES.UPGRADE_PREVENTION: "res://Images/ShopItems/turret_up.png",
	Enums.SHOP_TYPES.UPGRADE_ENCRYPTED: "res://Images/ShopItems/crypt_up.png",
	Enums.SHOP_TYPES.UPGRADE_WANDERING: "res://Images/ShopItems/wandering_up.png",
	
	Enums.SHOP_TYPES.BUY_MEGA_SHIELD: "res://Images/ShopItems/shield_mega.png",
	Enums.SHOP_TYPES.BUY_MEGA_WALL: "res://Images/ShopItems/wall_mega.png",
	Enums.SHOP_TYPES.BUY_MEGA_PREVENTION: "res://Images/ShopItems/turret_mega.png",
	Enums.SHOP_TYPES.BUY_MEGA_ENCRYPTED: "res://Images/ShopItems/crypt_mega.png",
	Enums.SHOP_TYPES.BUY_MEGA_WANDERING: "res://Images/ShopItems/wandering_mega.png",
	
	Enums.SHOP_TYPES.UPGRADE_ENERGY_PER_TICK: "res://Images/ShopItems/energy_buy.png",
	Enums.SHOP_TYPES.UPGRADE_MAX_ENERGY: "res://Images/ShopItems/energy_up.png",
	
	Enums.SHOP_TYPES.BUY_HOURGLASS_POWER_UP: "res://Images/Icons/Hourglass.png",
	Enums.SHOP_TYPES.BUY_BOMB_POWER_UP: "res://Images/Icons/Bomb.png",
}

onready var UPGRADE_BY_TYPE = {
	Enums.SHOP_TYPES.UPGRADE_SHIELD: Enums.HABILITIES.SHIELD,
	Enums.SHOP_TYPES.UPGRADE_WALL: Enums.HABILITIES.WALL,
	Enums.SHOP_TYPES.UPGRADE_PREVENTION: Enums.HABILITIES.PREVENTION,
	Enums.SHOP_TYPES.UPGRADE_ENCRYPTED: Enums.HABILITIES.ENCRYPTED_PIPE,
	Enums.SHOP_TYPES.UPGRADE_WANDERING: Enums.HABILITIES.WANDERING_FIREWALL,
	
	Enums.SHOP_TYPES.UPGRADE_HEALTH: 'max_health',
	Enums.SHOP_TYPES.UPGRADE_ENERGY_PER_TICK: 'energy_per_tick',
	Enums.SHOP_TYPES.UPGRADE_MAX_ENERGY: 'max_energy',
}

const BUY_BY_TYPE = {
	Enums.SHOP_TYPES.BUY_HEALTH: 'actual_health',
	
	Enums.SHOP_TYPES.BUY_WALL: 'wall',
	Enums.SHOP_TYPES.BUY_PREVENTION: 'prevention',
	Enums.SHOP_TYPES.BUY_ENCRYPTED: 'encrypted_pipe',
	Enums.SHOP_TYPES.BUY_WANDERING: 'wandering_firewall',
	
	Enums.SHOP_TYPES.BUY_MEGA_SHIELD: 'mega_shield',
	Enums.SHOP_TYPES.BUY_MEGA_WALL: 'mega_wall',
	Enums.SHOP_TYPES.BUY_MEGA_PREVENTION: 'mega_prevention',
	Enums.SHOP_TYPES.BUY_MEGA_ENCRYPTED: 'mega_encrypted_pipe',
	Enums.SHOP_TYPES.BUY_MEGA_WANDERING: 'mega_wandering_firewall',
	
	Enums.SHOP_TYPES.BUY_HOURGLASS_POWER_UP: 'hourglass_power_up',
	Enums.SHOP_TYPES.BUY_BOMB_POWER_UP: 'bomb_power_up',
}

const BUY_TYPES = [
	Enums.SHOP_TYPES.BUY_HEALTH,
	
	Enums.SHOP_TYPES.BUY_WALL,
	Enums.SHOP_TYPES.BUY_PREVENTION,
	Enums.SHOP_TYPES.BUY_ENCRYPTED,
	Enums.SHOP_TYPES.BUY_WANDERING,
	
	Enums.SHOP_TYPES.BUY_MEGA_SHIELD,
	Enums.SHOP_TYPES.BUY_MEGA_WALL,
	Enums.SHOP_TYPES.BUY_MEGA_PREVENTION,
	Enums.SHOP_TYPES.BUY_MEGA_ENCRYPTED,
	Enums.SHOP_TYPES.BUY_MEGA_WANDERING,
	
	Enums.SHOP_TYPES.BUY_HOURGLASS_POWER_UP,
	Enums.SHOP_TYPES.BUY_BOMB_POWER_UP,
]

const UPGRADE_TYPES = [
	Enums.SHOP_TYPES.UPGRADE_ENERGY_PER_TICK,
	Enums.SHOP_TYPES.UPGRADE_MAX_ENERGY,
	Enums.SHOP_TYPES.UPGRADE_HEALTH,
	
	Enums.SHOP_TYPES.UPGRADE_SHIELD,
	Enums.SHOP_TYPES.UPGRADE_WALL,
	Enums.SHOP_TYPES.UPGRADE_PREVENTION,
	Enums.SHOP_TYPES.UPGRADE_ENCRYPTED,
	Enums.SHOP_TYPES.UPGRADE_WANDERING,
]

const HABILITIES_TYPES = [
	Enums.SHOP_TYPES.UPGRADE_SHIELD,
	Enums.SHOP_TYPES.UPGRADE_WALL,
	Enums.SHOP_TYPES.UPGRADE_PREVENTION,
	Enums.SHOP_TYPES.UPGRADE_ENCRYPTED,
	Enums.SHOP_TYPES.UPGRADE_WANDERING,
]

onready var PRICE_LABEL = $GridContainer/Price

export(Enums.SHOP_TYPES) var TYPE

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
		Enums.SHOP_TYPES.BUY_WALL:
			TYPE = Enums.SHOP_TYPES.UPGRADE_WALL
		Enums.SHOP_TYPES.BUY_PREVENTION:
			TYPE = Enums.SHOP_TYPES.UPGRADE_PREVENTION
		Enums.SHOP_TYPES.BUY_ENCRYPTED:
			TYPE = Enums.SHOP_TYPES.UPGRADE_ENCRYPTED
		Enums.SHOP_TYPES.BUY_WANDERING:
			TYPE = Enums.SHOP_TYPES.UPGRADE_WANDERING
		
		Enums.SHOP_TYPES.BUY_MEGA_ENCRYPTED:
			analyse_self_destruct()
		Enums.SHOP_TYPES.BUY_MEGA_PREVENTION:
			analyse_self_destruct()
		Enums.SHOP_TYPES.BUY_MEGA_SHIELD:
			analyse_self_destruct()
		Enums.SHOP_TYPES.BUY_MEGA_WALL:
			analyse_self_destruct()
		Enums.SHOP_TYPES.BUY_MEGA_WANDERING:
			analyse_self_destruct()
		
		Enums.SHOP_TYPES.UPGRADE_SHIELD:
			TYPE = Enums.SHOP_TYPES.BUY_MEGA_SHIELD
		Enums.SHOP_TYPES.UPGRADE_WALL:
			TYPE = Enums.SHOP_TYPES.BUY_MEGA_WALL
		Enums.SHOP_TYPES.UPGRADE_PREVENTION:
			TYPE = Enums.SHOP_TYPES.BUY_MEGA_PREVENTION
		Enums.SHOP_TYPES.UPGRADE_ENCRYPTED:
			TYPE = Enums.SHOP_TYPES.BUY_MEGA_ENCRYPTED
		Enums.SHOP_TYPES.UPGRADE_WANDERING:
			TYPE = Enums.SHOP_TYPES.BUY_MEGA_WANDERING
		
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
	$Button.disabled = !(Global.PLAYER_INFOS['firewall_points'] >= actual_price) or is_maxed() or TYPE in BUY_TYPES and BUY_BY_TYPE[TYPE] in ['actual_health'] and Global.PLAYER_INFOS['actual_health'] == Global.PLAYER_INFOS['max_health'] or TYPE == Enums.SHOP_TYPES.BUY_HOURGLASS_POWER_UP and Engine.time_scale == 0.5 or TYPE == Enums.SHOP_TYPES.BUY_BOMB_POWER_UP and Global.bombed == true


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
				Enums.HABILITIES.SHIELD: 'up_shield',
				Enums.HABILITIES.WALL: 'up_wall',
				Enums.HABILITIES.PREVENTION: 'up_prevention',
				Enums.HABILITIES.ENCRYPTED_PIPE: 'up_encrypted_pipe',
				Enums.HABILITIES.WANDERING_FIREWALL: 'up_wandering_firewall',
			}
			GAME.show_info(CONVERSION_MAP[UPGRADE_BY_TYPE[TYPE]])
		else:
			GAME.show_info(UPGRADE_BY_TYPE[TYPE])
	else:
		GAME.show_info(BUY_BY_TYPE[TYPE])

func _on_Button_mouse_exited():
	GAME.reset_info()
