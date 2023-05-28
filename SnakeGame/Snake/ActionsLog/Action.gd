extends GridContainer

func _ready():
	Global.set_process_bit(self, false)

func Run(what: String, icon: String, amount):
	$WhatHappened.texture = load(Global.TEXTURES[what])
	$Icon.texture = load(Global.TEXTURES[icon])
	$Amount.text = str(amount)
