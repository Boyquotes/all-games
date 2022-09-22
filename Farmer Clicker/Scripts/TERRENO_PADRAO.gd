extends Node2D

#STATES: LIMPAR, ARAR, PLANTAR, REGAR, ESPERAR, COLHER

var SCENE_NUMBER: int

const TEXTURES = {
	'cenoura': ["res://Images/CROPS/CENOURA/CENOURA-1.png", "res://Images/CROPS/CENOURA/CENOURA-2.png", "res://Images/CROPS/CENOURA/CENOURA-3.png", "res://Images/CROPS/CENOURA/CENOURA-4.png"],
	'milho': ["res://Images/CROPS/MILHO/MILHO-1.png", "res://Images/CROPS/MILHO/MILHO-2.png", "res://Images/CROPS/MILHO/MILHO-3.png", "res://Images/CROPS/MILHO/MILHO-4.png"],
	'soja': ["res://Images/CROPS/SOJA/SOJA-1.png", "res://Images/CROPS/SOJA/SOJA-2.png", "res://Images/CROPS/SOJA/SOJA-3.png", "res://Images/CROPS/SOJA/SOJA-4.png"],
	'trigo': ["res://Images/CROPS/TRIGO/TRIGO-1.png", "res://Images/CROPS/TRIGO/TRIGO-2.png", "res://Images/CROPS/TRIGO/TRIGO-3.png", "res://Images/CROPS/TRIGO/TRIGO-4.png"],
	}

func _ready():
	SCENE_NUMBER = len(get_parent().get_children())-1
	if Global.INVENTORY['scenes_info'][SCENE_NUMBER][9] == 'regar':
		for z in $Node2D2.get_children():
			z.texture = load(TEXTURES[Global.INVENTORY['scenes_info'][SCENE_NUMBER][0]][0])
	self.add_user_signal("ACABOU", ['oq'])
# warning-ignore:return_value_discarded
	self.connect("ACABOU", self, "_on_ACABOU_signal_emited")

func _process(_delta):
	if len(Global.INVENTORY['scenes_info'][SCENE_NUMBER][4]) == 1:
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[0].visible = false
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[1].visible = true
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[1].texture = load(Global.WORKERS[Global.INVENTORY['scenes_info'][SCENE_NUMBER][4][0]])
	if len(Global.INVENTORY['scenes_info'][SCENE_NUMBER][4]) == 2:
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[0].visible = false
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[1].visible = true
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[1].texture = load(Global.WORKERS[Global.INVENTORY['scenes_info'][SCENE_NUMBER][4][0]])
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[2].visible = false
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[3].visible = true
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[3].texture = load(Global.WORKERS[Global.INVENTORY['scenes_info'][SCENE_NUMBER][4][2]])
	if len(Global.INVENTORY['scenes_info'][SCENE_NUMBER][4]) == 3:
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[0].visible = false
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[1].visible = true
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[1].texture = load(Global.WORKERS[Global.INVENTORY['scenes_info'][SCENE_NUMBER][4][0]])
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[2].visible = false
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[3].visible = true
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[3].texture = load(Global.WORKERS[Global.INVENTORY['scenes_info'][SCENE_NUMBER][4][2]])
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[4].visible = false
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[5].visible = true
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[5].texture = load(Global.WORKERS[Global.INVENTORY['scenes_info'][SCENE_NUMBER][4][4]])
	if len(Global.INVENTORY['scenes_info'][SCENE_NUMBER][4]) == 4:
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[0].visible = false
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[1].visible = true
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[1].texture = load(Global.WORKERS[Global.INVENTORY['scenes_info'][SCENE_NUMBER][4][0]])
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[2].visible = false
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[3].visible = true
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[3].texture = load(Global.WORKERS[Global.INVENTORY['scenes_info'][SCENE_NUMBER][4][2]])
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[4].visible = false
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[5].visible = true
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[5].texture = load(Global.WORKERS[Global.INVENTORY['scenes_info'][SCENE_NUMBER][4][4]])
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[6].visible = false
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[7].visible = true
		$WORKERS.find_node('WORKERS').find_node('GridContainer').get_children()[7].texture = load(Global.WORKERS[Global.INVENTORY['scenes_info'][SCENE_NUMBER][4][6]])
	var nodes = [$PROGRESSO/ENXADA,$PROGRESSO/RASTELO,$PROGRESSO/REGADOR,$PROGRESSO/COLHER,$PROGRESSO/ESPERAR, $Node2D]
	var node = null
	if Global.INVENTORY['scenes_info'][SCENE_NUMBER][9] == 'colher':
		node = $PROGRESSO/COLHER
	if Global.INVENTORY['scenes_info'][SCENE_NUMBER][9] == 'esperar':
		node = $PROGRESSO/ESPERAR
		$PROGRESSO/ESPERAR.value = Global.INVENTORY['scenes_info'][SCENE_NUMBER][5]
		if $PROGRESSO/ESPERAR.value > $PROGRESSO/ESPERAR.max_value*0.75:
			for z in $Node2D2.get_children():
				z.texture = load(TEXTURES[Global.INVENTORY['scenes_info'][SCENE_NUMBER][0]][0])
		if $PROGRESSO/ESPERAR.value <= $PROGRESSO/ESPERAR.max_value*0.75 and $PROGRESSO/ESPERAR.value > $PROGRESSO/ESPERAR.max_value*0.5:
			for z in $Node2D2.get_children():
				z.texture = load(TEXTURES[Global.INVENTORY['scenes_info'][SCENE_NUMBER][0]][1])
		if $PROGRESSO/ESPERAR.value <= $PROGRESSO/ESPERAR.max_value*0.5 and $PROGRESSO/ESPERAR.value > $PROGRESSO/ESPERAR.max_value*0.25:
			for z in $Node2D2.get_children():
				z.texture = load(TEXTURES[Global.INVENTORY['scenes_info'][SCENE_NUMBER][0]][2])
		if $PROGRESSO/ESPERAR.value <= $PROGRESSO/ESPERAR.max_value*0.25:
			for z in $Node2D2.get_children():
				z.texture = load(TEXTURES[Global.INVENTORY['scenes_info'][SCENE_NUMBER][0]][3])
	if Global.INVENTORY['scenes_info'][SCENE_NUMBER][9] == 'arar':
		node = $PROGRESSO/ENXADA
	if Global.INVENTORY['scenes_info'][SCENE_NUMBER][9] == 'limpar':
		node = $PROGRESSO/RASTELO
	if Global.INVENTORY['scenes_info'][SCENE_NUMBER][9] == 'regar':
		node = $PROGRESSO/REGADOR
	if Global.INVENTORY['scenes_info'][SCENE_NUMBER][9] == 'plantar':
		node = $Node2D
	if node != null:
		for z in nodes:
			if z == node:
				z.visible = true
			else:
				z.visible = false
	for z in $Node2D/PLANTAR/ScrollContainer/VBoxContainer/GridContainer.get_children():
		if z.find_node("TextureButton") != null:
			if z.find_node("TextureButton").pressed:
				Global.INVENTORY['scenes_info'][SCENE_NUMBER][1] = len(z.find_node("GridContainer").find_node("GridContainer2").find_node("GridContainer").get_children())
				Global.INVENTORY['scenes_info'][SCENE_NUMBER][0] = z.TYPE[0]
				for x in len(Global.INVENTORY['semente_de_'+Global.INVENTORY['scenes_info'][SCENE_NUMBER][0]]):
					if Global.INVENTORY['semente_de_'+Global.INVENTORY['scenes_info'][SCENE_NUMBER][0]][x] == ['semente_de_'+Global.INVENTORY['scenes_info'][SCENE_NUMBER][0], Global.INVENTORY['scenes_info'][SCENE_NUMBER][1]]:
						Global.INVENTORY['semente_de_'+Global.INVENTORY['scenes_info'][SCENE_NUMBER][0]].remove(x)
						break
				self.emit_signal("ACABOU", 'plantar')
	
	if Global.INVENTORY['scenes_info'][SCENE_NUMBER][10] == false:
		for z in ['semente_de_cenoura', 'semente_de_trigo', 'semente_de_milho', 'semente_de_soja']:
			if len(Global.INVENTORY[z]) != 0:
				Global.INVENTORY['scenes_info'][SCENE_NUMBER][10] = true
				SET_SEEDS()
				break

func SET_SEEDS():
	for z in $Node2D/PLANTAR/ScrollContainer/VBoxContainer/GridContainer.get_children():
		z.queue_free()
	for z in Global.ALL_PLANTS_LIST:
		if len(Global.INVENTORY['semente_de_'+z]) > 0:
			var raridades = {
				'1': 0,
				'2': 0,
				'3': 0,
				'4': 0,
				'5': 0,
			}
			for x in Global.INVENTORY['semente_de_'+z]:
				raridades[str(x[1])] += 1
			for y in range(1, 6):
				for _x in range(0, raridades[str(y)]):
					var node = preload("res://Scenes/Saquinho_de_semente.tscn").instance()
					node.TYPE = [z, y, raridades[str(y)]]
					$Node2D/PLANTAR/ScrollContainer/VBoxContainer/GridContainer.add_child(node)
	if len($Node2D/PLANTAR/ScrollContainer/VBoxContainer/GridContainer.get_children()) == 0:
		Global.INVENTORY['scenes_info'][SCENE_NUMBER][10] = false
		var node = Label.new()
		node.text = Global.TEXT[Global.LANGUAGE]['Você não possui nenhuma semente']
		$Node2D/PLANTAR/ScrollContainer/VBoxContainer/GridContainer.add_child(node)

func _on_ACABOU_signal_emited(oq):
	if oq == 'limpar':
		Global.INVENTORY['scenes_info'][SCENE_NUMBER][7] = 150 + Global.INVENTORY['scenes_info'][SCENE_NUMBER][2]*50
		$PROGRESSO/ENXADA.max_value = Global.INVENTORY['scenes_info'][SCENE_NUMBER][7]
		$PROGRESSO/ENXADA.value = 0
		Global.INVENTORY['scenes_info'][SCENE_NUMBER][9] = 'arar'
	if oq == 'arar':
		SET_SEEDS()
		Global.INVENTORY['scenes_info'][SCENE_NUMBER][9] = 'plantar'
	if oq == 'regar':
		Global.INVENTORY['scenes_info'][SCENE_NUMBER][9] = 'esperar'
		Global.INVENTORY['scenes_info'][SCENE_NUMBER][5] = Global.INVENTORY['scenes_info'][SCENE_NUMBER][1] * (Global.INVENTORY['scenes_info'][SCENE_NUMBER][1] * 150 + Global.INVENTORY['scenes_info'][SCENE_NUMBER][2]*50)
		$PROGRESSO/ESPERAR.max_value = Global.INVENTORY['scenes_info'][SCENE_NUMBER][5]
		$PROGRESSO/ESPERAR.value = Global.INVENTORY['scenes_info'][SCENE_NUMBER][5]
		$Timer.start()
	if oq == 'esperar':
		Global.INVENTORY['scenes_info'][SCENE_NUMBER][3] = Global.INVENTORY['scenes_info'][SCENE_NUMBER][1] * (Global.INVENTORY['scenes_info'][SCENE_NUMBER][1] * 10 + Global.INVENTORY['scenes_info'][SCENE_NUMBER][2]*10)
		$PROGRESSO/COLHER.max_value = Global.INVENTORY['scenes_info'][SCENE_NUMBER][3]
		$PROGRESSO/COLHER.value = Global.INVENTORY['scenes_info'][SCENE_NUMBER][3]
		Global.INVENTORY['scenes_info'][SCENE_NUMBER][9] = 'colher'
	if oq == 'colher':
		$Node2D2.visible = false
		Global.INVENTORY['scenes_info'][SCENE_NUMBER][9] = 'limpar'
		Global.INVENTORY['scenes_info'][SCENE_NUMBER][6] = 150 + Global.INVENTORY['scenes_info'][SCENE_NUMBER][2]*50
		$PROGRESSO/RASTELO.max_value = Global.INVENTORY['scenes_info'][SCENE_NUMBER][6]
		$PROGRESSO/RASTELO.value = 0
	if oq == 'plantar':
		$Node2D2.visible = true
		for z in $Node2D2.get_children():
			z.texture = load(TEXTURES[Global.INVENTORY['scenes_info'][SCENE_NUMBER][0]][0])
		Global.INVENTORY['scenes_info'][SCENE_NUMBER][8] = Global.INVENTORY['scenes_info'][SCENE_NUMBER][1] * (Global.INVENTORY['scenes_info'][SCENE_NUMBER][1] * 150 + Global.INVENTORY['scenes_info'][SCENE_NUMBER][2]*50)
		$PROGRESSO/REGADOR.max_value = Global.INVENTORY['scenes_info'][SCENE_NUMBER][8]
		$PROGRESSO/REGADOR.value = 0
		Global.INVENTORY['scenes_info'][SCENE_NUMBER][9] = 'regar'

func _on_TERRENO_button_down():
	if Global.INVENTORY['scenes_info'][SCENE_NUMBER][9] == 'colher':
		var valor_de_aumento = int((1+(Global.INVENTORY['nivel_luvas']-1)) * Global.INVENTORY['multiplicador'])
		if valor_de_aumento > Global.INVENTORY['scenes_info'][SCENE_NUMBER][3]:
			valor_de_aumento = Global.INVENTORY['scenes_info'][SCENE_NUMBER][3]
		Global.INVENTORY['scenes_info'][SCENE_NUMBER][3] -= valor_de_aumento
		Global.INVENTORY[Global.INVENTORY['scenes_info'][SCENE_NUMBER][0]] += valor_de_aumento
		$PROGRESSO/COLHER.value -= valor_de_aumento
		if Global.INVENTORY['scenes_info'][SCENE_NUMBER][3] == 0:
			self.emit_signal("ACABOU", 'colher')
	if Global.INVENTORY['scenes_info'][SCENE_NUMBER][9] == 'esperar':
		var valor_de_aumento = (1+(Global.INVENTORY['nivel_relogio']-1)) * Global.INVENTORY['multiplicador']
		Global.INVENTORY['scenes_info'][SCENE_NUMBER][5] -= valor_de_aumento
		$PROGRESSO/ESPERAR.value -= valor_de_aumento
		if Global.INVENTORY['scenes_info'][SCENE_NUMBER][5] <= 0:
			self.emit_signal("ACABOU", 'esperar')
	if Global.INVENTORY['scenes_info'][SCENE_NUMBER][9] == 'arar':
		var valor_de_aumento = (1+(Global.INVENTORY['nivel_enxada']-1)) * Global.INVENTORY['multiplicador']
		Global.INVENTORY['scenes_info'][SCENE_NUMBER][7] -= valor_de_aumento
		$PROGRESSO/ENXADA.value += valor_de_aumento
		if Global.INVENTORY['scenes_info'][SCENE_NUMBER][7] <= 0:
			self.emit_signal("ACABOU", 'arar')
		#criar um efeitinho de terra que é iniciado aleatoriamente dentro de uma área específica (que é a terra do terreno)
	if Global.INVENTORY['scenes_info'][SCENE_NUMBER][9] == 'limpar':
		var valor_de_aumento = (1+(Global.INVENTORY['nivel_rastelo']-1)) * Global.INVENTORY['multiplicador']
		Global.INVENTORY['scenes_info'][SCENE_NUMBER][6] -= valor_de_aumento
		$PROGRESSO/RASTELO.value += valor_de_aumento
		if Global.INVENTORY['scenes_info'][SCENE_NUMBER][6] <= 0:
			self.emit_signal("ACABOU", 'limpar')
	if Global.INVENTORY['scenes_info'][SCENE_NUMBER][9] == 'regar':
		var valor_de_aumento = (1+(Global.INVENTORY['nivel_regador']-1)) * Global.INVENTORY['multiplicador']
		Global.INVENTORY['scenes_info'][SCENE_NUMBER][8] -= valor_de_aumento
		$PROGRESSO/REGADOR.value += valor_de_aumento
		if Global.INVENTORY['scenes_info'][SCENE_NUMBER][8] <= 0:
			self.emit_signal("ACABOU", 'regar')
	if Global.INVENTORY['scenes_info'][SCENE_NUMBER][9] != 'plantar':
		Global.INVENTORY['cliques'] += 1
		Global.INVENTORY['total_cliques'] += 1
#valores para limpar, arar, plantar, regar, esperar e colher serão dados ao escolher a planta à ser plantada
#isso será de acordo com o nível do terreno, e qualidade da semente
#qualidade da colheita será dada pelo nível da rega que será determinada pelo nível do arado, que será determinado pelo nível da limpeza

func _on_Timer_timeout():
	if Global.INVENTORY['scenes_info'][SCENE_NUMBER][5] <= 0:
		self.emit_signal("ACABOU", 'esperar')
	if Global.INVENTORY['scenes_info'][SCENE_NUMBER][9] == 'esperar':
		Global.INVENTORY['scenes_info'][SCENE_NUMBER][5] -= 1
		$Timer.start()
	else:
		$Timer.stop()



