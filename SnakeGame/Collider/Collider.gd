extends Node2D

enum TYPE {
	WALL = 0,
	HANDLER_LEFT = 1,
	HANDLER_RIGHT = 2,
	HANDLER_TOP = 3,
	HANDLER_BOTTOM = 4,
	
	COIN = 5,
	ENEMY = 6,
	SHOP = 7,
	UPGRADE = 8,#aumentar em 1 o atributo escolhido, em troca de crescer em 1 a cobra (ESSA É A GOLDEN APPLE)
	
	OBJECTIVE = 9
	EXP = 10#sempre 1 de xp ganho ao pegar isso
	
	TRAP = 11#pode atirar um projétil de dano físico ou um da dano mágico em 4 direções diferentes (cima, baixo, esquerda, direita)
}

export(TYPE) var type
var manager



func _ready():
	Global.set_process_bit(self, false)
	AnalyseColor()

func AnalyseColor():
	set_modulate(Global.COLLIDER_COLORS[type])
	if type == 9 && manager.ActualObjectives[0] == self:
		set_modulate(Color(0.5, 0.2, 0.7))

func VerifyDuplicated():
	for z in get_tree().get_nodes_in_group("Collider"):
		if z != self && z.global_position == global_position && (type in [1, 2, 3, 4] && z.type in [1, 2, 3, 4]):#&& (z.type in [1, 2, 3, 4] && type in [1, 2, 3, 4])
			get_parent().DOORS.remove(get_parent().DOORS.find(self))
			queue_free()
			break

func Die():
	manager.exceps.remove(manager.exceps.find(self))
	queue_free()
