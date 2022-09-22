extends Button

var GLASS_OR_CATEGORY: String

func _on_SEE_THIS_GLASS_OR_CATEGORY_button_up():
	if GLASS_OR_CATEGORY == 'CATEGORY':
		get_tree().get_nodes_in_group('MAIN')[0].get_node('SEE/A/SEE_ALL_CATEGORIES/ScrollContainer/VBoxContainer/CATEGORIES').visible = false
		get_tree().get_nodes_in_group('MAIN')[0].get_node('SEE/A/SEE_ALL_CATEGORIES/ScrollContainer/VBoxContainer/DRINKS').visible = true
		get_tree().get_nodes_in_group('MAIN')[0].SHOW_DRINKS_BY_CATEGORIES(self.text)
	else:
		get_tree().get_nodes_in_group('MAIN')[0].get_node('SEE/A/SEE_ALL_GLASS/ScrollContainer/VBoxContainer/GLASS').visible = false
		get_tree().get_nodes_in_group('MAIN')[0].get_node('SEE/A/SEE_ALL_GLASS/ScrollContainer/VBoxContainer/DRINKS').visible = true
		get_tree().get_nodes_in_group('MAIN')[0].SHOW_DRINKS_BY_GLASS(self.text)
