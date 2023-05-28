extends TextureButton

const TEXTURES = {
	Global.HABILITIES.SHIELD: "res://Images/Habilities/Shield.png",
	Global.HABILITIES.WALL: "res://Images/Habilities/Wall.png",
	Global.HABILITIES.PREVENTION: "res://Images/Habilities/Prevention.png",
	Global.HABILITIES.WANDERING_FIREWALL: "res://Images/Habilities/Wandering.png",
	Global.HABILITIES.ENCRYPTED_PIPE: "res://Images/Habilities/Top_pipe.png",
}

var HABILITIES = {
	Global.HABILITIES.SHIELD: 'shield',
	Global.HABILITIES.WALL: 'wall',
	Global.HABILITIES.PREVENTION: 'prevention',
	Global.HABILITIES.WANDERING_FIREWALL: 'wandering_firewall',
	Global.HABILITIES.ENCRYPTED_PIPE: 'encrypted_pipe',
}

var mega = false

export(Global.HABILITIES) var TYPE

onready var sprite = $Sprite

onready var GAME = get_tree().get_nodes_in_group("GAME")[0]

func _ready():
	sprite.texture = load(TEXTURES[TYPE])

func _on_HabilityButton_button_up():
	pass

func _on_HabilityButton_button_down():
	pressed = false
	
	Global.buy(HABILITIES[TYPE], Global.HABILITIES_COST[TYPE])
	Global.play_sound('button_pressed')

var MEGA_TEXTURES = {
	Global.HABILITIES.SHIELD: "res://Images/MegaHabilities/Shield.png",
	Global.HABILITIES.WALL: "res://Images/MegaHabilities/Wall.png",
	Global.HABILITIES.PREVENTION: "res://Images/MegaHabilities/Prevention.png",
	Global.HABILITIES.WANDERING_FIREWALL: "res://Images/MegaHabilities/Wandering.png",
	Global.HABILITIES.ENCRYPTED_PIPE: "res://Images/MegaHabilities/Top_pipe.png"
}

func _physics_process(_delta):
	if "mega_" + HABILITIES[TYPE] in Global.PLAYER_INFOS['mega_habilities']:
		$Sprite.texture = load(MEGA_TEXTURES[TYPE])
		mega = true
		set_physics_process(false)

func _process(_delta):
	disabled = !Global.can_buy(Global.HABILITIES_COST[TYPE])

func _on_HabilityButton_mouse_entered():
	if mega:
		GAME.show_info(Global.MEGA_BY_HABILITY[TYPE])
	else:
		GAME.show_info(HABILITIES[TYPE])

func _on_HabilityButton_mouse_exited():
	GAME.reset_info()
