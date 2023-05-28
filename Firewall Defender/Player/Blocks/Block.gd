extends Node2D

const HANDLER = 'BLOCK_HANDLER'
const SELF_GROUP = 'BLOCK'

var max_health = 1
var actual_health = 1

var multiple = false

onready var HABILITY = get_parent().TYPE

func setup_block(max_h, actual_h, multip):
	self.max_health = max_h
	self.actual_health = actual_h
	self.multiple = multip

func has_mega():
	return Global.MEGA_BY_HABILITY[HABILITY] in Global.PLAYER_INFOS['mega_habilities']

func take_hit(damage):
	if multiple == false:
		actual_health -= abs(damage)
		
		if actual_health == 0:
			get_parent().die()
	else:
		get_parent().take_hit(1)

func _process(_delta):
	if is_physics_processing() and Input.is_action_just_released("lmb_release"):
		on_button_up()

func _physics_process(_delta):
	get_parent().global_position = Vector2(stepify(get_global_mouse_position()[0], 8), stepify(get_global_mouse_position()[1], 8))

func on_button_down():
	set_physics_process(true)

func on_button_up():
	set_physics_process(false)
	
	var distances = []
	for z in get_tree().get_nodes_in_group(HANDLER):
		var do = true
		for x in get_tree().get_nodes_in_group(SELF_GROUP):
			if x.global_position == z.global_position and x != self:
				do = false
				break
		if do == true:
			distances.append(global_position.distance_to(z.global_position))
		else:
			distances.append(99999)
	get_parent().global_position = get_tree().get_nodes_in_group(HANDLER)[distances.find(distances.min())].global_position
	
	if has_mega():
		var blocks = return_filtered_blocks(HABILITY)
		
		var self_blocks = get_parent().get_children()
		
		for z in blocks:
			if z.global_position in [
				Vector2(global_position.x, global_position.y-16),
				Vector2(global_position.x, global_position.y+16),
				Vector2(global_position.x-16, global_position.y),
				Vector2(global_position.x+16, global_position.y)
			] and !(z in self_blocks):
				change_to_mega()
				break

func change_to_mega():
	match HABILITY:
		Global.HABILITIES.SHIELD:
			setup_block(actual_health+1, actual_health+1, false)
			get_parent().BLOCK.get_child(0).texture = preload("res://Images/MegaHabilities/Shield.png")
		Global.HABILITIES.WALL:
			setup_block(actual_health+1, actual_health+1, true)
			
			for z in get_parent().get_children():
				z.get_child(0).texture = preload("res://Images/MegaHabilities/Wall.png")
		Global.HABILITIES.PREVENTION:
			get_parent().mega = true
			get_parent().get_child(0).get_child(0).texture = preload("res://Images/MegaHabilities/Prevention.png")
		Global.HABILITIES.ENCRYPTED_PIPE:
			setup_block(actual_health+1, actual_health+1, true)
			
			for z in get_parent().get_children():
				z.get_child(0).texture = preload("res://Images/MegaHabilities/Pipe.png")
			
			get_parent().get_child(0).get_child(0).texture = preload("res://Images/MegaHabilities/Top_pipe.png")
			get_parent().get_child(len(get_parent().get_children())-1).get_child(0).texture = preload("res://Images/MegaHabilities/Bottom_pipe.png")

func return_filtered_blocks(type_to_filter):
	var blocks = get_tree().get_nodes_in_group("BLOCK")
	
	var filtered_blocks = []
	
	for z in blocks:
		if z.HABILITY == type_to_filter:
			filtered_blocks.append(z)
	
	return filtered_blocks
