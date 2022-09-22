extends CheckBox

export(String) var DIA
export(String) var TIPO

func _on_SEM_PREFERENCIA_NAO_QUER_toggled(button_pressed):
	if TIPO == 'sem_preferencia_nao_quer':
		get_tree().get_nodes_in_group('ADICIONAR_PROFESSOR')[0].emit_signal("NAO_QUER_SIGNAL_EMMITED", DIA, button_pressed)
	if TIPO == 'sem_preferencia_quer':
		get_tree().get_nodes_in_group('ADICIONAR_PROFESSOR')[0].emit_signal("QUER_SIGNAL_EMMITED", DIA, button_pressed)
	if TIPO == 'motivo_quer':
		get_tree().get_nodes_in_group('ADICIONAR_PROFESSOR')[0].emit_signal("MOTIVO_QUER_SIGNAL_EMMITED", DIA, button_pressed)
	if TIPO == 'motivo_nao_quer':
		get_tree().get_nodes_in_group('ADICIONAR_PROFESSOR')[0].emit_signal("MOTIVO_NAO_QUER_SIGNAL_EMMITED", DIA, button_pressed)


func _on_MOTIVO_SIM_NAO_toggled(button_pressed):
	pass # Replace with function body.
