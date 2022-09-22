extends Control

func _get_drag_data(_at_position):
	var data = get_child(0)
	
	var control = Control.new()
	var label = Label.new()
	label.text = get_child(0).text
	control.add_child(label)
	set_drag_preview(control)
	
	return data

func _can_drop_data(_at_position, data):
	if data.text != null:
		return true
	else:
		return false

func _drop_data(_at_position, data):
	get_child(0).text = data.text
