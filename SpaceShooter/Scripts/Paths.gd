extends Node2D

var REFERENCE_NODE
var index = 0
var Choosen

func _ready():
	Global.set_process_bit(self, false)
	set_process(true)
	Choosen = Global.RANDOM.randi_range(0, len(get_children())-1)

func _process(_delta):
	if abs(REFERENCE_NODE.global_position[0] - get_child(Choosen).points[index][0]) < 8 and abs(REFERENCE_NODE.global_position[1] - get_child(Choosen).points[index][1]) < 8:
		index += 1
	if len(get_child(Choosen).points) == index:
		index = 0
	var DIR = REFERENCE_NODE.global_position.direction_to(get_child(Choosen).points[index])
	REFERENCE_NODE.global_position += DIR * 3.5
