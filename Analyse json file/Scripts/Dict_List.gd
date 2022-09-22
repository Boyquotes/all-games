extends GridContainer

var info = []

func _on_Button_toggled(button_pressed):
	if button_pressed:
		for z in range(1, len(get_children())):
			get_child(z).visible = true
	else:
		for z in range(1, len(get_children())):
			get_child(z).visible = false

func _on_Delete_button_up():
	var buffer = get_tree().get_nodes_in_group("MAIN")[0].jasao
	for z in range(0, len(info)):
		buffer = buffer[info[z]]
	
	var NewJson = get_tree().get_nodes_in_group("MAIN")[0].jasao
	
	print(get_tree().get_nodes_in_group("MAIN")[0].jasao)
	print('-----')
	print(buffer)
	#get_tree().get_nodes_in_group("MAIN")[0].emit_signal("Delete")
