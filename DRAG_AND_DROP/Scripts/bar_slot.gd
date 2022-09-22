extends Control

var DATA = [] #img(String), ore name, type, origin node

func _get_drag_data(_at_position):
	var data = DATA
	
	var control = Control.new()
	var texturere = TextureRect.new()
	texturere.expand = true
	texturere.texture = load(data[0])
	control.add_child(texturere)
	texturere.rect_position = Vector2(-32, -32)
	set_drag_preview(control)
	
	return data

func _can_drop_data(_at_position, data):
	if data[2] == 'BAR':
		return true
	else:
		return false

func _drop_data(_at_position, data):
	DATA = data
	$IMG.texture = load(DATA[0])
	DATA[3].find
