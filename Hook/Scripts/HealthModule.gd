extends Node

var died = false

var FULL_HEARTH = preload("res://Images/Others/Heart.png")
var EMPTY_HEARTH = preload("res://Images/Others/EmptyHeart.png")

func take_dmg(DMG: int, healthGridView: GridContainer, ACTUAL_HP, MAX_HP):
	if ACTUAL_HP != 0:
		ACTUAL_HP -= DMG
	
	if len(healthGridView.get_children()) < ACTUAL_HP:
		add_hearth_view(healthGridView, FULL_HEARTH)
	else:
		var health_difference = MAX_HP - ACTUAL_HP
		
		healthGridView.get_child(
			len(healthGridView.get_children()) -health_difference
			).texture = EMPTY_HEARTH
		
		if ACTUAL_HP == 0 and died == false:
			died = true
	
	return ACTUAL_HP

func add_hearth_view(healthGridView, texture):
	var textur = TextureRect.new()
	textur.texture = texture
	healthGridView.call_deferred("add_child", textur)

func setup_health_view(healthGridView: GridContainer, MAX_HP):
	for z in healthGridView.get_children():
		z.queue_free()
	
	died = false
	
	if MAX_HP > 10:
		healthGridView.columns = 10
	else:
		healthGridView.columns = MAX_HP
	
	for _z in MAX_HP:
		add_hearth_view(healthGridView, FULL_HEARTH)

