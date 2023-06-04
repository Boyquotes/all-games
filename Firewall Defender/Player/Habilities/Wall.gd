extends Node2D

var max_health
var actual_health

var TYPE = Enums.HABILITIES.WALL

func add_new_block():
	var block = preload("res://Player/Blocks/Block.tscn").instance()
	var spr = Sprite.new()
	spr.texture = preload("res://Images/Habilities/Wall.png")
	
	block.add_child(spr)
	
	add_child(block)

func _ready():
	var health = Global.UPGRADES[Enums.HABILITIES.WALL][2] + 3
	
	max_health = health
	actual_health = health
	
	for _z in range(0, Global.UPGRADES[Enums.HABILITIES.WALL][2]-1):
		add_new_block()
	
	var int_buffer = 0
	
	for z in get_children():
		z.global_position = Vector2(global_position.x + int_buffer * 16, global_position.y)
		int_buffer += 1
	
	var size = len(get_children())
	
	if size % 2 == 0:
		while get_child((size / 2) - 1).global_position.x != global_position.x:
			for z in get_children():
				z.global_position.x -= 16
	else:
		while get_child(size - floor(size / 2) - 1).global_position.x != global_position.x:
			for z in get_children():
				z.global_position.x -= 16
	
	for z in get_children():
		z.setup_block(1, 1, true)
	
	max_health = len(get_children())+1
	actual_health = max_health

func die():
	queue_free()

func take_hit(damage):
	actual_health -= abs(damage)
	
	if actual_health == 0:
		die()
