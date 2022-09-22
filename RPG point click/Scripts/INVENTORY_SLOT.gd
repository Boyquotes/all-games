extends TextureRect

func get_drag_data(_position):
	var inv_slot
	for z in range(0, len(get_parent().get_children())):
		if get_parent().get_children()[z] == self:
			inv_slot = z
			break
	
	if Global.PLAYER_DATA['INVENTORY'][inv_slot] != null:
		var data = {}
		data['origin'] = 'INVENTORY'
		data['origin_texture'] = load(Global.PLAYER_DATA['INVENTORY'][inv_slot][13])
		data['origin_item'] = Global.PLAYER_DATA['INVENTORY'][inv_slot]
		data['origin_index'] = inv_slot
		var drag_texture = TextureRect.new()
		drag_texture.expand = true
		drag_texture.texture = load(Global.PLAYER_DATA['INVENTORY'][inv_slot][13])
		drag_texture.rect_size = Vector2(64, 64)
		
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.rect_position = -0.5 * drag_texture.rect_size
		
		set_drag_preview(control)
		
		return data
	

func can_drop_data(_position, _data):
	var inv_slot
	for z in range(0, len(get_parent().get_children())):
		if get_parent().get_children()[z] == self:
			inv_slot = z
			break
	if Global.PLAYER_DATA['INVENTORY'][inv_slot] == null:
		return true
	else:
		return false
	

func drop_data(_position, data):
	var inv_slot
	for z in range(0, len(get_parent().get_children())):
		if get_parent().get_children()[z] == self:
			inv_slot = z
			break
	texture = data['origin_texture']
	if data['origin'] == 'INVENTORY':
		get_parent().get_child(data['origin_index']).texture = preload("res://icon.png")
		Global.PLAYER_DATA['INVENTORY'][data['origin_index']] = null
	if data['origin'] == 'EQUIPAMENT':
		var TEXTURES = {
			'HEAD': "res://icon.png",
			'SHOULDER1': "res://icon.png",
			'SHOULDER2': "res://icon.png",
			'CHEST': "res://icon.png",
			'FOREARM1': "res://icon.png",
			'FOREARM2': "res://icon.png",
			'PANTS': "res://icon.png",
			'WEAPON1': "res://icon.png",
			'WEAPON2': "res://icon.png",
			'FEET1': "res://icon.png",
			'FEET2': "res://icon.png",
			'RING1': "res://icon.png",
			'RING2': "res://icon.png",
			'AMULET1': "res://icon.png",
			'AMULET2': "res://icon.png",
		}
		get_tree().get_nodes_in_group(data['origin_position'])[0].texture = load(TEXTURES[data['origin_position']])
		Global.ADD_STATS(data['origin_position'], data['origin_item'], true)
		Global.PLAYER_DATA[data['origin_position']] = null
	Global.PLAYER_DATA['INVENTORY'][inv_slot] = data['origin_item']


