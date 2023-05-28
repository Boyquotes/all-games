extends CheckBox

func _on_BotaoAlternativa_button_up():
	get_parent().get_parent().get_parent().get_parent().SetAnswer(self.get_parent().get_child(1).text)
