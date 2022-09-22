extends Camera2D
func _on_Area2D_area_entered(area):
	area = area.get_parent()
	if area.is_in_group("PLAYER"):
		area.SetCamera(self)
