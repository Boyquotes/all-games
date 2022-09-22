extends Area2D

var list = []

func _ready():
	Global.set_process_bit(self, false)

func _on_PARRY_AREA_area_entered(area):
	area = area.get_parent()
	if area.is_in_group("ENEMY"):
		list.append(area)

func _on_PARRY_AREA_area_exited(area):
	area = area.get_parent()
	if area.is_in_group("ENEMY"):
		list.remove(list.find(area))
