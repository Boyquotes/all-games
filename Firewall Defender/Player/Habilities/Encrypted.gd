extends Node2D

var TYPE = Enums.HABILITIES.ENCRYPTED_PIPE

func die():
	get_child(0).queue_free()
	
	if len(get_children()) == 0:
		queue_free()

func add_new_block():
	var block = preload("res://Player/Blocks/Block.tscn").instance()
	var spr = Sprite.new()
	spr.texture = preload("res://Images/Habilities/Pipe.png")
	
	block.add_child(spr)
	
	add_child(block)

func _ready():
	for _z in range(0, Enums.UPGRADES[Enums.HABILITIES.ENCRYPTED_PIPE][2]-1):
		add_new_block()
	
	var int_buffer = 0
	
	for z in get_children():
		z.global_position = Vector2(global_position.x, global_position.y + int_buffer * 16)
		int_buffer += 1
	
	var size = len(get_children())
	
	if size % 2 == 0:
		while get_child((size / 2) - 1).global_position.y != global_position.y:
			for z in get_children():
				z.global_position.y -= 16
	else:
		while get_child(size - floor(size / 2) - 1).global_position.y != global_position.y:
			for z in get_children():
				z.global_position.y -= 16
	
	for z in get_children():
		z.setup_block(1, 1, false)
	
	get_child(0).get_child(0).texture = load("res://Images/Habilities/Top_pipe.png")
	get_child(len(get_children())-1).get_child(0).texture = load("res://Images/Habilities/Bottom_pipe.png")
