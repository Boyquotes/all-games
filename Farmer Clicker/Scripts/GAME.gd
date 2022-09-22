extends Node2D

#LEMBRAR DE OBRIGAR O PLAYER A JOGAR COM INTERNET NO DISPOSITIVO

#O TEMPO DO JOGO SÓ PASSA SE O JOGADOR ESTIVER NO JOGO -> obrigar o player a ficar no game com intervalos curtos de espera

#NIVEL MAXIMO 99 full

#RELÓGIO MÁGICO QUE O VÔ DELE DEU PRA ELE = AVANÇAR O TEMPO EM ESPERAR, o relógio e uma ferramenta e pode ser upado, mas não avança o tempo da estação

#COMPRAR SEMENTES É UMA LISTA COM 6 OPÇÕES DE SEMENTE (INDEPENDENTE DA ÉPOCA), MAS TEM REFRESH DA LISTA COM DINHEIRO OU DIAMANTES
#banquinha com as 6 sementes dispostas (duas linhas de 3)
#rich seed info com as informações das sementes e o botão de comprar
#oq ta aqui em cima vale o msm pros workers, mas só vão aparecer 4 workers pra escolher

#PASSA DE ESTAÇÃO A CADA HORA DENTRO DO GAME
#OQ ACONTECE EM CADA ESTAÇÃO:
#PRIMAVERA:
#
#VERÃO:
#
#OUTONO:
#
#INVERNO:
#


#sistemas de estação para aumentar os ganhos com cada plantio (avisar com mensagem fora do game que estação que está, para chamar o player pro jogo)
#uma planta fora da estação é mais cara para comprar e para vender, já uma planta da estação é mais barata para comprar e para vender

#SISTEMA DE ANIMAIS igualzinho o Hay Day, só produz dps de comer

#estágios de crescimento da plantação:
#semente -> igual para todas
#planta em 25% do crescimento
#planta em 50% do crescimento
#planta em 75% do crescimento
#planta pronta para colher


#CRIAR: 
#terreno para comprar - com plaquinha de preço
#terreno pronto pra limpar - rastelo
#terreno pronto para arar - enxada
#terreno arado seco - regador
#terreno arado úmido - plantar

#FAZER ICONES DE:
#RASTELO
#ENXADA
#REGADOR
#

#TO-FILLS:
#NIVEL = #3000a7
#ENXADA = #a74a00
#REGADOR = #0baa91
#RASTELO = #a4302e
#COLHER = #3f7e1b



#ANIMAIS:
#tipo 1 - não morre
#vaca - come ração(milho e soja) e dps de um tempo produz leite de vaca (o player clicka para obter os itens como se fosse no sistema das plantações e o animal não morre)
#galinha - come ração(milho e trigo) e dps de um tempo produz ovos (o player clicka para obter os itens como se fosse no sistema das plantações e o animal não morre)
#cabra - come ração(milho e cenoura) e dps de um tempo produz leite de cabra (o player clicka para obter os itens como se fosse no sistema das plantações e o animal não morre)
#ovelha - come ração(trigo e soja) e dps de um tempo produz lã (o player clicka para obter os itens como se fosse no sistema das plantações e o animal não morre)
#() - come ração(trigo e cenoura) e dps de um tempo 
#() - come ração(cenoura e soja) e dps de um tempo 
#tipo 2 - morre
#porco - come ração(milho, soja, trigo e cenoura) e dps de um tempo fica apto para ser abatido (o player clica nele e um porco morre na hora dando uma quantia de carne de porco)
#boi - come ração(milho, soja, trigo e cenoura) e dps de um tempo fica apto para ser abatido (o player clica nele e um boi morre na hora dando uma quantia de carne de boi)

var actual_shop_item
var actual_worker

func _ready():
	$RICH_OBJ_VIEW/GridContainer/GridContainer2/GridContainer/GridContainer/GridContainer3/BUY.text = Global.TEXT[Global.LANGUAGE]['Comprar']
	
	$COMPRAR/GridContainer/TabContainer/Upgrades/GridContainer/VBoxContainer/GridContainer/GridContainer/Label.text = Global.TEXT[Global.LANGUAGE]['Item']
	$COMPRAR/GridContainer/TabContainer/Upgrades/GridContainer/VBoxContainer/GridContainer/GridContainer/Label2.text = Global.TEXT[Global.LANGUAGE]['Nível']
	$COMPRAR/GridContainer/TabContainer/Upgrades/GridContainer/VBoxContainer/GridContainer/GridContainer/Label3.text = Global.TEXT[Global.LANGUAGE]['Melhorar']
	$COMPRAR/GridContainer/TabContainer/Upgrades/GridContainer/VBoxContainer/GridContainer/GridContainer/Label4.text = Global.TEXT[Global.LANGUAGE]['Custo']
	self.add_user_signal("SET_WORKER_VIEW", ['obj'])
# warning-ignore:return_value_discarded
	self.connect("SET_WORKER_VIEW", self, "_on_SET_WORKER_VIEW_SIGNAL_EMMITED")
	
	self.add_user_signal("CLOSE_BUTTON_PRESSED", ['where'])
# warning-ignore:return_value_discarded
	self.connect("CLOSE_BUTTON_PRESSED", self, "_on_CLOSE_BUTTON_SIGNAL_EMMITED")
	
	self.add_user_signal("SET_RICH_OBJ_VIEW", ['obj'])
# warning-ignore:return_value_discarded
	self.connect("SET_RICH_OBJ_VIEW", self, "_on_SET_RICH_OBJ_VIEW_SIGNAL_EMMITED")
	
	self.add_user_signal("TOOLBAR_BUTTON_PRESSED", ['type'])
# warning-ignore:return_value_discarded
	self.connect("TOOLBAR_BUTTON_PRESSED", self, "_on_TOOLBAR_BUTTON_PRESSED")

func _process(_delta):
	if Input.is_action_just_pressed("ui_up"):
		emit_signal("TOOLBAR_BUTTON_PRESSED", 'COMPRAR')
	
	$ESTATISTICAS/GridContainer/TabContainer/Statistics/GridContainer/VBoxContainer/GridContainer/GridContainer/Label2.text = str(Global.INVENTORY['multiplicador'])
	
	$ESTATISTICAS/GridContainer/TabContainer/Statistics/GridContainer/VBoxContainer/GridContainer/GridContainer2/Label2.text = str(Global.INVENTORY['money'])
	
	$ESTATISTICAS/GridContainer/TabContainer/Statistics/GridContainer/VBoxContainer/GridContainer/GridContainer3/Label2.text = str(Global.INVENTORY['diamonds'])
	
	$ESTATISTICAS/GridContainer/TabContainer/Statistics/GridContainer/VBoxContainer/GridContainer/GridContainer4/Label2.text = str(Global.INVENTORY['nivel'])
	
	$ESTATISTICAS/GridContainer/TabContainer/Statistics/GridContainer/VBoxContainer/GridContainer/GridContainer5/Label2.text = str(Global.INVENTORY['total_cliques'])
	
	$ESTATISTICAS/GridContainer/TabContainer/Statistics/GridContainer/VBoxContainer/GridContainer/GridContainer6/Label2.text = str(Global.INVENTORY['maximum_shop_items'])
	
	if Global.INVENTORY['actual_scene'] == 0:
		$ESQUERDA.visible = false
	else:
		$ESQUERDA.visible = true
	if Global.INVENTORY['actual_scene'] == len(Global.INVENTORY['scenes_list'])-1:
		$DIREITA.visible = false
	else:
		$DIREITA.visible = true
	
	$GridContainer/INFORMACOES/NIVEL.max_value = (Global.INVENTORY['nivel'] * 10000 + (Global.INVENTORY['nivel']-1*5000))
	$GridContainer/INFORMACOES/NIVEL.value = Global.INVENTORY['cliques']
	$GridContainer/INFORMACOES/NIVEL/Label.text = str(Global.INVENTORY['nivel'])
	
	$GridContainer/INFORMACOES/DINHEIRO/Label.text = str(Global.INVENTORY['money'])
	$GridContainer/INFORMACOES/DINHEIRO/Label2.text = str(Global.INVENTORY['diamonds'])
	
	$COMPRAR/GridContainer/TabContainer/Seeds/GridContainer2/GridContainer/GridContainer/PRICE.text = str(Global.INVENTORY['refresh_price'])
	
	if Global.INVENTORY['estacao_atual'] == 'Spring':
		$GridContainer/INFORMACOES/GridContainer/ESTACAO.texture = load("res://Images/SPRING.png")
	if Global.INVENTORY['estacao_atual'] == 'Summer':
		$GridContainer/INFORMACOES/GridContainer/ESTACAO.texture = load("res://Images/SUMMER.png")
	if Global.INVENTORY['estacao_atual'] == 'Autumn':
		$GridContainer/INFORMACOES/GridContainer/ESTACAO.texture = load("res://Images/AUTUMN.png")
	if Global.INVENTORY['estacao_atual'] == 'Winter':
		$GridContainer/INFORMACOES/GridContainer/ESTACAO.texture = load("res://Images/WINTER.png")
	
	if int($RICH_OBJ_VIEW/GridContainer/GridContainer2/GridContainer/GridContainer/GridContainer3/GridContainer/OUTPUT_PRICE.text) > Global.INVENTORY['money']:
		$RICH_OBJ_VIEW/GridContainer/GridContainer2/GridContainer/GridContainer/GridContainer3/BUY.disabled = true
	else:
		$RICH_OBJ_VIEW/GridContainer/GridContainer2/GridContainer/GridContainer/GridContainer3/BUY.disabled = false
	
	if Global.INVENTORY['money'] < Global.INVENTORY['refresh_price']:
		$COMPRAR/GridContainer/TabContainer/Seeds/GridContainer2/GridContainer/REFRESH_WITH_GOLD.disabled = true
	else:
		$COMPRAR/GridContainer/TabContainer/Seeds/GridContainer2/GridContainer/REFRESH_WITH_GOLD.disabled = false
	if Global.INVENTORY['diamonds'] < 1:
		$COMPRAR/GridContainer/TabContainer/Seeds/GridContainer2/GridContainer2/REFRESH_WITH_DIAMONDS.disabled = true
	else:
		$COMPRAR/GridContainer/TabContainer/Seeds/GridContainer2/GridContainer2/REFRESH_WITH_DIAMONDS.disabled = false

func _on_SET_WORKER_VIEW_SIGNAL_EMMITED(obj):
	actual_worker = obj[0]
	$RICH_OBJ_VIEW/GridContainer/GridContainer3.visible = true
	$RICH_OBJ_VIEW/GridContainer/GridContainer2/TextureRect.texture = load(obj[1])
	$RICH_OBJ_VIEW/GridContainer/GridContainer2/GridContainer/GridContainer/GridContainer3/BUY.visible = false
	$RICH_OBJ_VIEW/GridContainer/GridContainer2/GridContainer/GridContainer/GridContainer3/HIRE.visible = true
	$RICH_OBJ_VIEW/GridContainer/GridContainer2/GridContainer/GridContainer/GridContainer3/HIRE.text = Global.TEXT[Global.LANGUAGE]['Contratar']
	$RICH_OBJ_VIEW/GridContainer/GridContainer/Label.text = Global.TEXT[Global.LANGUAGE]['workers'][str(obj[0])][0]
	$RICH_OBJ_VIEW/GridContainer/GridContainer2/GridContainer/GridContainer2/Label.visible = false
	$RICH_OBJ_VIEW/GridContainer/Label.text = Global.TEXT[Global.LANGUAGE]['Descrição']
	$RICH_OBJ_VIEW/GridContainer/Label2.text = Global.TEXT[Global.LANGUAGE]['workers'][str(obj[0])][1]
	$RICH_OBJ_VIEW/GridContainer/GridContainer2/GridContainer/GridContainer/GridContainer3/GridContainer/OUTPUT_PRICE.text = str(obj[4])
	$RICH_OBJ_VIEW/GridContainer/GridContainer3/INTERVAL/Label.text = str(obj[2])
	$RICH_OBJ_VIEW/GridContainer/GridContainer3/HIT/Label.text = str(obj[3])
	$RICH_OBJ_VIEW/GridContainer/GridContainer3/TAX/Label.text = str(obj[4])
	$RICH_OBJ_VIEW/GridContainer/GridContainer3/PAY/Label.text = str(obj[5])
	
	$RICH_OBJ_VIEW.visible = true
	for z in $RICH_OBJ_VIEW/GridContainer/GridContainer2/GridContainer/GridContainer2/GridContainer.get_children():
		z.queue_free()

func _on_SET_RICH_OBJ_VIEW_SIGNAL_EMMITED(obj):
	$RICH_OBJ_VIEW/GridContainer/GridContainer3.visible = false
	$RICH_OBJ_VIEW/GridContainer/GridContainer2/GridContainer/GridContainer/GridContainer3/HIRE.visible = false
	$RICH_OBJ_VIEW/GridContainer/GridContainer2/GridContainer/GridContainer/GridContainer3/BUY.visible = true
	$RICH_OBJ_VIEW/GridContainer/GridContainer2/GridContainer/GridContainer/GridContainer3/BUY.text = Global.TEXT[Global.LANGUAGE]['Comprar']
	$RICH_OBJ_VIEW/GridContainer/GridContainer2/GridContainer/GridContainer2/Label.visible = true
	$RICH_OBJ_VIEW/GridContainer/Label.text = Global.TEXT[Global.LANGUAGE]['Descrição']
	for z in len(Global.SHOP):
		if Global.SHOP[z] == obj:
			actual_shop_item = Global.SHOP[z]
			break
	$RICH_OBJ_VIEW.visible = true
	$VENDER.visible = false
	$RICH_OBJ_VIEW/GridContainer/GridContainer2/TextureRect.texture = load(Global.TEXTURES[obj[0]])
	for z in $RICH_OBJ_VIEW/GridContainer/GridContainer2/GridContainer/GridContainer2/GridContainer.get_children():
		z.queue_free()
	for _z in range(0, obj[1]):
		var node = TextureRect.new()
		node.set_custom_minimum_size(Vector2(30, 30))
		node.set_expand(true)
		node.texture = load("res://Images/ICONES_DE_JOGABILIDADE/ESTRELA.png")#estrela
		$RICH_OBJ_VIEW/GridContainer/GridContainer2/GridContainer/GridContainer2/GridContainer.add_child(node)
	$RICH_OBJ_VIEW/GridContainer/Label2.text = Global.TEXT[Global.LANGUAGE]['descricoes'][obj[0]]
	$RICH_OBJ_VIEW/GridContainer/GridContainer/Label.text = Global.TEXT[Global.LANGUAGE]['nomes'][obj[0]]
	$RICH_OBJ_VIEW/GridContainer/GridContainer2/GridContainer/GridContainer/GridContainer3/GridContainer/OUTPUT_PRICE.text = str(Global.BASE_PRICES[obj[0]+'-'+str(obj[1])])

func _on_CLOSE_BUTTON_SIGNAL_EMMITED(where):
	if where == 'MAPA':
		$MAPA.visible = false
	if where == 'COMPRAR':
		$COMPRAR.visible = false
	if where == 'VENDER':
		$VENDER.visible = false
		for z in $VENDER/GridContainer/TabContainer/Crops/GridContainer/VBoxContainer.get_children():
			z.queue_free()
		for z in $"VENDER/GridContainer/TabContainer/Animal products/GridContainer/VBoxContainer".get_children():
			z.queue_free()
	if where == 'CRAFT':
		$CRAFT.visible = false
	if where == 'ESTATISTICAS':
		$ESTATISTICAS.visible = false
		for z in $ESTATISTICAS/GridContainer/TabContainer/Inventory/GridContainer/VBoxContainer/GridContainer.get_children():
			z.queue_free()
	if where == 'RICH_OBJ_VIEW':
		$RICH_OBJ_VIEW.visible = false

func _on_TOOLBAR_BUTTON_PRESSED(type):
	var nodes = [$CRAFT,$MAPA,$VENDER,$ESTATISTICAS, $COMPRAR]
	var node
	if type == 'MAPA':
		node = $MAPA
	if type == 'COMPRAR':
		for z in $COMPRAR/GridContainer/TabContainer/Seeds/GridContainer.get_children():
			z.queue_free()
		for z in $COMPRAR/GridContainer/TabContainer/Upgrades/GridContainer/VBoxContainer/GridContainer/GridContainer2.get_children():
			z.queue_free()
		for z in Global.SHOP:
			var nod = preload("res://Scenes/Poor_obj_view.tscn").instance()
			nod.OBJ = z
			nod.TYPE = 'item'
			$COMPRAR/GridContainer/TabContainer/Seeds/GridContainer.add_child(nod)
		for z in ['maximum_workers_shop', 'maximum_shop_items', 'nivel_rastelo', 'nivel_enxada', 'nivel_regador', 'nivel_relogio', 'nivel_luvas']:
			var noode = preload("res://Scenes/UPGRADE.tscn").instance()
			noode.ITEM = [z]
			$COMPRAR/GridContainer/TabContainer/Upgrades/GridContainer/VBoxContainer/GridContainer/GridContainer2.add_child(noode)
		node = $COMPRAR
	if type == 'VENDER':
		node = $VENDER
		for z in $VENDER/GridContainer/TabContainer/Crops/GridContainer/VBoxContainer.get_children():
			z.queue_free()
		for z in $"VENDER/GridContainer/TabContainer/Animal products/GridContainer/VBoxContainer".get_children():
			z.queue_free()
		for z in Global.ALL_PLANTS_LIST:
			if Global.INVENTORY[z] > 0:
				var noude = preload("res://Scenes/Sell_item.tscn").instance()
				noude.ITEM = z
				$VENDER/GridContainer/TabContainer/Crops/GridContainer/VBoxContainer.add_child(noude)
		for z in Global.ALL_ANIMAL_PRODUCTS_LIST:
			if Global.INVENTORY[z] > 0:
				var noude = preload("res://Scenes/Sell_item.tscn").instance()
				noude.ITEM = z
				$"VENDER/GridContainer/TabContainer/Animal products/GridContainer/VBoxContainer".add_child(noude)
	if type == 'CRAFT':
		node = $CRAFT
	if type == 'ESTATISTICAS':
		node = $ESTATISTICAS
		for z in ['cenoura', 'trigo', 'milho', 'soja', 'leite_vaca', 'leite_cabra', 'carne_boi', 'carne_porco', 'ovo', 'la']:
			var grid = GridContainer.new()
			var texture = TextureRect.new()
			var label = Label.new()
			grid.set_columns(2)
			grid.set_h_size_flags(3)
			texture.set_expand(true)
			texture.set_custom_minimum_size(Vector2(80, 80))
			texture.texture = load(Global.TEXTURES[z])
			label.text = str(Global.INVENTORY[z])
			grid.add_child(texture)
			grid.add_child(label)
			$ESTATISTICAS/GridContainer/TabContainer/Inventory/GridContainer/VBoxContainer/GridContainer.add_child(grid)
		if len($ESTATISTICAS/GridContainer/TabContainer/Inventory/GridContainer/VBoxContainer/GridContainer.get_children()) == 0:
			var label = Label.new()
			label.text = Global.TEXT[Global.LANGUAGE]['Você não tem nenhum item']
			$ESTATISTICAS/GridContainer/TabContainer/Inventory/GridContainer/VBoxContainer/GridContainer.add_child(label)
	for z in nodes:
		if z == node:
			z.visible = true
		else:
			z.visible = false

func ADD_SCENE(scene):
	Global.INVENTORY['scenes_list'].append(scene)
	var node = load(Global.INVENTORY['scenes_list'][Global.INVENTORY['actual_scene']]).instance()
	node.global_position = Vector2((len(Global.INVENTORY['scenes_list'])*414), 192)
	$STABILIZER.add_child(node)

func SWAP_SCENE(right_left: String):
	var a = 0
	if right_left == 'right':
		a = 1
	if right_left == 'left':
		a = -1
	for _z in range(0, 414):
		$STABILIZER.global_position[0] = 1 * a
		yield(get_tree().create_timer(0.01), "timeout")

func _on_DIREITA_button_up():
	SWAP_SCENE('right')

func _on_ESQUERDA_button_up():
	SWAP_SCENE('left')

func _on_ESTACAO_timeout():
	if Global.INVENTORY['estacao_time_remaining'] == 0:
		var estacoes = {
			'Spring': 'Summer',
			'Summer': 'Autumn',
			'Autumn': 'Winter',
			'Winter': 'Spring',
		}
		Global.INVENTORY['estacao_atual'] = estacoes[Global.INVENTORY['estacao_atual']]
		Global.INVENTORY['estacao_time_remaining'] = 900
		$GridContainer/INFORMACOES/GridContainer/ProgressBar.value = 0
	else:
		Global.INVENTORY['estacao_time_remaining'] -= 1
		$GridContainer/INFORMACOES/GridContainer/ProgressBar.value += 1
	$ESTACAO.start()

func SET_SHOP_ITEMS():
	for z in $COMPRAR/GridContainer/TabContainer/Seeds/GridContainer/VBoxContainer/GridContainer.get_children():
		z.queue_free()
	for z in Global.SHOP:
		var nod = preload("res://Scenes/Poor_obj_view.tscn").instance()
		nod.OBJ = z
		nod.TYPE = 'item'
		$COMPRAR/GridContainer/TabContainer/Seeds/GridContainer/VBoxContainer/GridContainer.add_child(nod)
	Global.SHOP.clear()
	for z in Global.INVENTORY['maximum_shop_items']:
		var luck = randi()%100 + 1
		if luck < 51:
			luck = 1
		if luck > 50 and luck < 77:
			luck = 2
		if luck > 76 and luck < 93:
			luck = 3
		if luck > 92 and luck < 99:
			luck = 4
		if luck > 98:
			luck = 5
		Global.SHOP.append([Global.INVENTORY['shop_possibilities'][randi()%len(Global.INVENTORY['shop_possibilities'])], luck])

func _on_REFRESH_WITH_GOLD_button_up():
	Global.INVENTORY['money'] -= Global.INVENTORY['refresh_price']
	Global.INVENTORY['refresh_price'] += 1
	SET_SHOP_ITEMS()

func _on_REFRESH_WITH_DIAMONDS_button_up():
	Global.INVENTORY['diamonds'] -= 1
	SET_SHOP_ITEMS()

func _on_BUY_button_up():
	var a
	for z in len(Global.SHOP):
		if Global.SHOP[z] == actual_shop_item:
			a = z
			break
	Global.INVENTORY['money'] -= Global.BASE_PRICES[actual_shop_item[0]+'-'+str(actual_shop_item[1])]
	Global.INVENTORY[actual_shop_item[0]].append(actual_shop_item)
	Global.SHOP.remove(a)
	$COMPRAR/GridContainer/TabContainer/Seeds/GridContainer/VBoxContainer/GridContainer.get_child(a).queue_free()
	$RICH_OBJ_VIEW.visible = false

func _on_HIRE_button_up():
	Global.INVENTORY['money'] -= int($RICH_OBJ_VIEW/GridContainer/GridContainer2/GridContainer/GridContainer/GridContainer3/GridContainer/OUTPUT_PRICE.text)
	$RICH_OBJ_VIEW.visible = false
	$STABILIZER.get_child(Global.INVENTORY['actual_scene']).CROP['workers'].append(actual_worker)
	Global.INVENTORY['workers_contratados'].append(actual_worker)
	Global.INVENTORY['scenes_info'][Global.INVENTORY['actual_scene']][4].append(actual_worker)
