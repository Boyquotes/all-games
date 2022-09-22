extends Node2D

#parse_json()

var jasao

var VERSIONS = []

onready var MainNode = $GridContainer/GridContainer/VBoxContainer/GridContainer

func Poor_json_Analisys(info, deep):
	var text = ''
	for z in deep:
		text += '-'
	match typeof(info):
		TYPE_DICTIONARY:
			print(text+'dct')
			for z in info:
				Poor_json_Analisys(info[z], deep+1)
		TYPE_ARRAY:
			print(text+'arr')
			for z in info:
				Poor_json_Analisys(z, deep+1)
		TYPE_INT:
			print(text+'int')
		TYPE_STRING:
			print(text+'str')

func Analyse_json(info, nam='', reference = null, prefix='',force_name=null, accumulated_path=[]):
	#'/main/boss/0/batata/15'
	
	match typeof(info):
		TYPE_DICTIONARY:
			var node = preload("res://Scenes/Dict_List.tscn").instance()
			node.get_child(0).get_child(0).get_child(0).text = 'Dictionary: ' + nam
			node.get_child(0).get_child(0).get_child(1).pressed = true
			for z in accumulated_path:
				node.info.append(z)
			if nam != '':
				node.info.append(nam)
			if reference == null:
				MainNode.add_child(node)
			else:
				var ref = preload("res://Scenes/Reference.tscn").instance()
				ref.add_child(node)
				reference.add_child(ref)
			for z in info:
				Analyse_json(info[z], z, node, 'Key: ',z, node.info)
		TYPE_ARRAY:
			var node = preload("res://Scenes/Dict_List.tscn").instance()
			node.get_child(0).get_child(0).get_child(0).text = 'List: ' + nam
			node.get_child(0).get_child(0).get_child(1).pressed = true
			for z in accumulated_path:
				node.info.append(z)
			if nam != '':
				node.info.append(nam)
			if reference == null:
				MainNode.add_child(node)
			else:
				var ref = preload("res://Scenes/Reference.tscn").instance()
				ref.add_child(node)
				reference.add_child(ref)
			for z in range(0, len(info)):
				Analyse_json(info[z], '', node, 'Index: ',z, node.info)
		TYPE_REAL:
			var node = preload("res://Scenes/Dict_List.tscn").instance()
			node.get_child(0).get_child(0).get_child(0).text = prefix+str(force_name)
			node.get_child(0).get_child(0).get_child(1).pressed = true
			var Lab = Label.new()
			Lab.text = str(info)
			Lab.set_h_size_flags(3)
			Lab.set_align(Label.ALIGN_CENTER)
			Lab.set_valign(Label.ALIGN_CENTER)
			node.add_child(Lab)
			for z in accumulated_path:
				node.info.append(z)
			node.info.append(force_name)
			if reference == null:
				MainNode.add_child(node)
			else:
				var ref = preload("res://Scenes/Reference.tscn").instance()
				ref.add_child(node)
				reference.add_child(ref)
		TYPE_STRING:
			var node = preload("res://Scenes/Dict_List.tscn").instance()
			if force_name != null:
				node.get_child(0).get_child(0).get_child(0).text = prefix+str(force_name)
			node.get_child(0).get_child(0).get_child(1).pressed = true
			var Lab = Label.new()
			Lab.text = info
			Lab.set_h_size_flags(3)
			Lab.set_align(Label.ALIGN_CENTER)
			Lab.set_valign(Label.ALIGN_CENTER)
			node.add_child(Lab)
			for z in accumulated_path:
				node.info.append(z)
			node.info.append(force_name)
			if reference == null:
				MainNode.add_child(node)
			else:
				var ref = preload("res://Scenes/Reference.tscn").instance()
				ref.add_child(node)
				reference.add_child(ref)

func _on_FileDialog_file_selected(path):
	var file = File.new()
	file.open(path, file.READ)
	var json = file.get_as_text()
	jasao = parse_json(json)
	file.close()
	
	
	Analyse_json(jasao)

func _on_FILE_SELECTOR_button_up():
	$FileDialog.popup()
