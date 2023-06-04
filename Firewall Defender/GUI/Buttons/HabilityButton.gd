extends TextureButton

onready var TEXTURES = {
	Enums.HABILITIES.SHIELD: "res://Images/Habilities/Shield.png",
	Enums.HABILITIES.WALL: "res://Images/Habilities/Wall.png",
	Enums.HABILITIES.PREVENTION: "res://Images/Habilities/Prevention.png",
	Enums.HABILITIES.WANDERING_FIREWALL: "res://Images/Habilities/Wandering.png",
	Enums.HABILITIES.ENCRYPTED_PIPE: "res://Images/Habilities/Top_pipe.png",
}

onready var HABILITIES = {
	Enums.HABILITIES.SHIELD: 'shield',
	Enums.HABILITIES.WALL: 'wall',
	Enums.HABILITIES.PREVENTION: 'prevention',
	Enums.HABILITIES.WANDERING_FIREWALL: 'wandering_firewall',
	Enums.HABILITIES.ENCRYPTED_PIPE: 'encrypted_pipe',
}

var mega = false

export(Enums.HABILITIES) var TYPE

onready var sprite = $Sprite

onready var GAME = get_tree().get_nodes_in_group("GAME")[0]

func _ready():
	sprite.texture = load(TEXTURES[TYPE])

func _on_HabilityButton_button_up():
	pass

func _on_HabilityButton_button_down():
	pressed = false
	
	Global.buy(HABILITIES[TYPE], Dicts.HABILITIES_COST[TYPE])
	Global.play_sound('button_pressed')

onready var MEGA_TEXTURES = {
	Enums.HABILITIES.SHIELD: "res://Images/MegaHabilities/Shield.png",
	Enums.HABILITIES.WALL: "res://Images/MegaHabilities/Wall.png",
	Enums.HABILITIES.PREVENTION: "res://Images/MegaHabilities/Prevention.png",
	Enums.HABILITIES.WANDERING_FIREWALL: "res://Images/MegaHabilities/Wandering.png",
	Enums.HABILITIES.ENCRYPTED_PIPE: "res://Images/MegaHabilities/Top_pipe.png"
}

func _physics_process(_delta):
	if "mega_" + HABILITIES[TYPE] in Global.PLAYER_INFOS['mega_habilities']:
		$Sprite.texture = load(MEGA_TEXTURES[TYPE])
		mega = true
		set_physics_process(false)

func _process(_delta):
	disabled = !Global.can_buy(Dicts.HABILITIES_COST[TYPE])

func _on_HabilityButton_mouse_entered():
	if mega:
		GAME.show_info(Dicts.MEGA_BY_HABILITY[TYPE])
	else:
		GAME.show_info(HABILITIES[TYPE])

func _on_HabilityButton_mouse_exited():
	GAME.reset_info()
