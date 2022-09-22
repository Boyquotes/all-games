extends Node2D

var INVENTORY = []

func _ready():
	Global.set_process_bit(self, false)
