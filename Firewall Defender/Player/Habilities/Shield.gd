extends Node2D

var TYPE = Enums.HABILITIES.SHIELD

func _ready():
	var health = Global.UPGRADES[Enums.HABILITIES.SHIELD][2] + 1
	
	get_child(0).setup_block(health, health, false)

onready var BLOCK = get_child(0)

func _process(_delta):
	if BLOCK.actual_health == 1:
		if BLOCK.get_child(0).get_texture() == preload("res://Images/Habilities/Shield.png"):
			BLOCK.get_child(0).texture = preload("res://Images/Habilities/BrokenShield.png")
		else:
			BLOCK.get_child(0).texture = preload("res://Images/MegaHabilities/BrokenShield.png")
		set_process(false)

func die():
	queue_free()
