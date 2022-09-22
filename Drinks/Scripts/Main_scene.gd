extends Node2D

var last_drink_got_by_id
var analising = false

var actual_rich_drink_view: String

#DISCOVER = RANDOM DRINK (DRINK ALEATÓRIO MOSTRADO NO INÍCIO DA PÁGINA), SHOW DRINKS BY ALCOHOLIC OR NOT, SHOW BY GLASS, SHOW BY CATEGORY
#COCKTAILS = SHOW DRINKS BY FIRST LETTER, SEARCH DRINKS, SHOW DRINKS BY INGREDIENT, SHOW INGREDIENTS - button to show all drinks in alphabetic order

#ALL CATEGORIES = www.thecocktaildb.com/api/json/v1/1/list.php?c=list
#ALL GLASS = www.thecocktaildb.com/api/json/v1/1/list.php?g=list
#ALL INGREDIENTS = www.thecocktaildb.com/api/json/v1/1/list.php?i=list
#ALL ALCOHOLIC = www.thecocktaildb.com/api/json/v1/1/filter.php?a=Alcoholic
#ALL NON-ALCOHOLIC = www.thecocktaildb.com/api/json/v1/1/filter.php?a=Non_Alcoholic

var TO_DO = [['show_random_cocktail'], ['show_alcoholic_drinks'], ['show_non_alcoholic_drinks'], ['show_drinks_by_glass', 'Highball glass'], ['show_drinks_by_categories', 'Cocktail'], ['see_all_categories'], ['see_all_glass'], ['search_by_first_letter', 'a']]

var JASAO

var current_screen: String
func _ready():
	self.add_user_signal("TASK_COMPLETED")
	self.add_user_signal("ALL_TASKS_COMPLETED")

	self.add_user_signal("SEARCH_BY_FIRST_LETTER_TASK_COMPLETED")
	self.add_user_signal("SHOW_RANDOM_COCKTAIL_TASK_COMPLETED")
	self.add_user_signal("SHOW_ALCOHOLIC_DRINKS_TASK_COMPLETED")
	self.add_user_signal("SHOW_NON_ALCOHOLIC_DRINKS_TASK_COMPLETED")
	self.add_user_signal("SHOW_DRINKS_BY_GLASS_TASK_COMPLETED")
	self.add_user_signal("SHOW_DRINKS_BY_CATEGORIES_TASK_COMPLETED")
	self.add_user_signal("SEE_ALL_CATEGORIES_TASK_COMPLETED")
	self.add_user_signal("SEE_ALL_INGREDIENTS_TASK_COMPLETED")
	self.add_user_signal("SEE_ALL_GLASS_TASK_COMPLETED")
	self.add_user_signal("SEE_ALL_FAVORITES_TASK_COMPLETED")
	self.add_user_signal("SEE_RICH_INGREDIENT_INFO_TASK_COMPLETED")
	
	current_screen = 'DISCOVER'
	$GridContainer/THE_FOUR/DISCOVER.set_modulate(Color(0.937255, 0.423529, 0))
# warning-ignore:return_value_discarded
	$MEGA_REQUESTER.connect("request_completed", self, "_on_MEGA_REQUESTER_request_completed")

func SEE_ALL_CATEGORIES():
	$MEGA_REQUESTER.request("https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list")
	yield($MEGA_REQUESTER, "request_completed")
	for z in $SEE/A/SEE_ALL_CATEGORIES/ScrollContainer/VBoxContainer/CATEGORIES.get_children():
		z.free()
	if JASAO.result != null:
		if JASAO.result['drinks'] != null:
			for z in JASAO.result['drinks']:
				var node = preload("res://Scenes/SEE_THIS_GLASS_OR_CATEGORY.tscn").instance()
				node.GLASS_OR_CATEGORY = 'CATEGORY'
				node.flat = true
				node.set_enabled_focus_mode(Control.FOCUS_NONE)
				node.text = z['strCategory']
				node.set_h_size_flags(3)
				node.set_expand_icon(true)
				node.set_custom_minimum_size(Vector2(256, 128))
				node.set_modulate(Color(0.937255, 0.423529, 0))
				$SEE/A/SEE_ALL_CATEGORIES/ScrollContainer/VBoxContainer/CATEGORIES.call_deferred("add_child", node)
	self.emit_signal("SEE_ALL_CATEGORIES_TASK_COMPLETED")

func SEE_ALL_INGREDIENTS():
	#if JASAO.result != null:
	#	if JASAO.result['drinks'] != null:
	#		for z in JASAO.result['drinks']:
	#			pass
	self.emit_signal("SEE_ALL_INGREDIENTS_TASK_COMPLETED")

func SEE_ALL_GLASS():
	$MEGA_REQUESTER.request("https://www.thecocktaildb.com/api/json/v1/1/list.php?g=list")
	yield($MEGA_REQUESTER, "request_completed")
	for z in $SEE/A/SEE_ALL_GLASS/ScrollContainer/VBoxContainer/GLASS.get_children():
		z.free()
	if JASAO.result != null:
		if JASAO.result['drinks'] != null:
			for z in JASAO.result['drinks']:
				var node = preload("res://Scenes/SEE_THIS_GLASS_OR_CATEGORY.tscn").instance()
				node.GLASS_OR_CATEGORY = 'GLASS'
				node.flat = true
				node.set_enabled_focus_mode(Control.FOCUS_NONE)
				node.text = z['strGlass']
				node.set_h_size_flags(3)
				node.set_expand_icon(true)
				node.set_custom_minimum_size(Vector2(256, 128))
				node.set_modulate(Color(0.937255, 0.423529, 0))
				$SEE/A/SEE_ALL_GLASS/ScrollContainer/VBoxContainer/GLASS.call_deferred("add_child", node)
	self.emit_signal("SEE_ALL_GLASS_TASK_COMPLETED")

func SHOW_DRINKS_BY_CATEGORIES(category):
	$SEE/A/SEE_ALL_CATEGORIES/ScrollContainer/VBoxContainer/CATEGORIES.visible = false
	$SEE/A/SEE_ALL_CATEGORIES/ScrollContainer/VBoxContainer/DRINKS.visible = true
	$SEE/A/SEE_ALL_CATEGORIES/CATEGORIES.text = 'Showing all drinks in: ' + category
	$MEGA_REQUESTER.request("https://www.thecocktaildb.com/api/json/v1/1/filter.php?c="+category)
	yield($MEGA_REQUESTER, "request_completed")
	for z in $SEE/A/SEE_ALL_CATEGORIES/ScrollContainer/VBoxContainer/DRINKS.get_children():
		z.free()
	if JASAO.result != null:
		var JAZAZ = JASAO
		if len($GridContainer/DISCOVER_TAB/VBoxContainer/CATEGORIES/HBoxContainer.get_children()) < 10:
			for z in $GridContainer/DISCOVER_TAB/VBoxContainer/CATEGORIES/HBoxContainer.get_children():
				z.free()
			for z in range(0, 10):
				GET_DRINK_BY_ID(JAZAZ.result['drinks'][z]['idDrink'], [$GridContainer/DISCOVER_TAB/VBoxContainer/CATEGORIES/HBoxContainer])
				yield(self, "TASK_COMPLETED")
		else:
			if len($SEE/A/SEE_ALL_CATEGORIES/ScrollContainer/VBoxContainer/DRINKS.get_children()) < 10:
				for z in JAZAZ.result['drinks']:
					if $SEE/A/SEE_ALL_CATEGORIES.visible == true:
						GET_DRINK_BY_ID(z['idDrink'], [$SEE/A/SEE_ALL_CATEGORIES/ScrollContainer/VBoxContainer/DRINKS])
						yield(self, "TASK_COMPLETED")
					else:
						break
	self.emit_signal("SHOW_DRINKS_BY_CATEGORIES_TASK_COMPLETED")

func SHOW_DRINKS_BY_GLASS(glass):
	$SEE/A/SEE_ALL_GLASS/ScrollContainer/VBoxContainer/GLASS.visible = false
	$SEE/A/SEE_ALL_GLASS/ScrollContainer/VBoxContainer/DRINKS.visible = true
	$MEGA_REQUESTER.request("https://www.thecocktaildb.com/api/json/v1/1/filter.php?g="+glass)
	yield($MEGA_REQUESTER, "request_completed")
	for z in $SEE/A/SEE_ALL_GLASS/ScrollContainer/VBoxContainer/DRINKS.get_children():
		z.free()
	if JASAO.result != null:
		var JAZAZ = JASAO
		if len($GridContainer/DISCOVER_TAB/VBoxContainer/GLASS/HBoxContainer.get_children()) < 10:
			for z in $GridContainer/DISCOVER_TAB/VBoxContainer/GLASS/HBoxContainer.get_children():
				z.free()
			for z in range(0, 10):
				GET_DRINK_BY_ID(JAZAZ.result['drinks'][z]['idDrink'], [$GridContainer/DISCOVER_TAB/VBoxContainer/GLASS/HBoxContainer])
				yield(self, "TASK_COMPLETED")
		else:
			$SEE/A/SEE_ALL_GLASS/GLASS.text = 'Showing all drinks in: ' + glass
			if len($SEE/A/SEE_ALL_GLASS/ScrollContainer/VBoxContainer/DRINKS.get_children()) < 10:
				for z in JAZAZ.result['drinks']:
					if $SEE/A/SEE_ALL_GLASS.visible == true:
						GET_DRINK_BY_ID(z['idDrink'], [$SEE/A/SEE_ALL_GLASS/ScrollContainer/VBoxContainer/DRINKS])
						yield(self, "TASK_COMPLETED")
					else:
						break
	self.emit_signal("SHOW_DRINKS_BY_GLASS_TASK_COMPLETED")

func SHOW_NON_ALCOHOLIC_DRINKS():
	for z in $SEE/A/SEE_NON_ALCOHOLIC_DRINKS/ScrollContainer/VBoxContainer/DRINKS.get_children():
		z.free()
	$MEGA_REQUESTER.request("https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Non_Alcoholic")
	yield($MEGA_REQUESTER, "request_completed")
	if JASAO.result != null:
		var JAZAZ = JASAO
		if len($GridContainer/DISCOVER_TAB/VBoxContainer/NON_ALCOCHOLICS/HBoxContainer.get_children()) < 10:
			for z in $GridContainer/DISCOVER_TAB/VBoxContainer/NON_ALCOCHOLICS/HBoxContainer.get_children():
				z.free()
			for z in range(0, 10):
				GET_DRINK_BY_ID(JAZAZ.result['drinks'][z]['idDrink'], [$GridContainer/DISCOVER_TAB/VBoxContainer/NON_ALCOCHOLICS/HBoxContainer])
				yield(self, "TASK_COMPLETED")
		else:
			if len($SEE/A/SEE_NON_ALCOHOLIC_DRINKS/ScrollContainer/VBoxContainer/DRINKS.get_children()) < 10:
				for z in JAZAZ.result['drinks']:
					if $SEE/A/SEE_NON_ALCOHOLIC_DRINKS.visible == true:
						GET_DRINK_BY_ID(z['idDrink'], [$SEE/A/SEE_NON_ALCOHOLIC_DRINKS/ScrollContainer/VBoxContainer/DRINKS])
						yield(self, "TASK_COMPLETED")
					else:
						break
	self.emit_signal("SHOW_NON_ALCOHOLIC_DRINKS_TASK_COMPLETED")

func SHOW_ALCOHOLIC_DRINKS():
	for z in $SEE/A/SEE_ALCOHOLIC_DRINKS/ScrollContainer/VBoxContainer/DRINKS.get_children():
		z.free()
	$MEGA_REQUESTER.request("https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Alcoholic")
	yield($MEGA_REQUESTER, "request_completed")
	if JASAO.result != null:
		var JAZAZ = JASAO
		if len($GridContainer/DISCOVER_TAB/VBoxContainer/ALCOHOLICS/HBoxContainer.get_children()) < 10:
			for z in $GridContainer/DISCOVER_TAB/VBoxContainer/ALCOHOLICS/HBoxContainer.get_children():
				z.free()
			for z in range(0, 10):
				GET_DRINK_BY_ID(JAZAZ.result['drinks'][z]['idDrink'], [$GridContainer/DISCOVER_TAB/VBoxContainer/ALCOHOLICS/HBoxContainer])
				yield(self, "TASK_COMPLETED")
		else:
			if len($SEE/A/SEE_ALCOHOLIC_DRINKS/ScrollContainer/VBoxContainer/DRINKS.get_children()) < 10:
				for z in JAZAZ.result['drinks']:
					if $SEE/A/SEE_ALCOHOLIC_DRINKS.visible == true:
						GET_DRINK_BY_ID(z['idDrink'], [$SEE/A/SEE_ALCOHOLIC_DRINKS/ScrollContainer/VBoxContainer/DRINKS])
						yield(self, "TASK_COMPLETED")
					else:
						break
	self.emit_signal("SHOW_ALCOHOLIC_DRINKS_TASK_COMPLETED")

func SHOW_RANDOM_COCKTAIL():
	for z in $GridContainer/DISCOVER_TAB/VBoxContainer/THE_RANDOM_COCKTAIL.get_children():
		z.free()
	$MEGA_REQUESTER.request("https://www.thecocktaildb.com/api/json/v1/1/random.php")
	yield($MEGA_REQUESTER, "request_completed")
	if JASAO.result != null:
		if JASAO.result['drinks'] != null:
			SET_POOR_DRINK_VIEW(JASAO, [$GridContainer/DISCOVER_TAB/VBoxContainer/THE_RANDOM_COCKTAIL])
	self.emit_signal("SHOW_RANDOM_COCKTAIL_TASK_COMPLETED")

func SEARCH_BY_FIRST_LETTER(letter:String):
	for z in $GridContainer/First_letter_searched_view/VBoxContainer/GridContainer.get_children():
		z.free()
		print(z)
	$MEGA_REQUESTER.request("https://www.thecocktaildb.com/api/json/v1/1/search.php?f="+letter)
	$GridContainer/Searched.text = 'Drinks with first letter: ' + letter
	for z in $GridContainer/First_letter_selector/HBoxContainer/GridContainer.get_children():
		if z.name == letter:
			z.set_modulate(Color(0.937255, 0.423529, 0))
		else:
			z.set_modulate(Color(1, 1, 1))
	yield($MEGA_REQUESTER, "request_completed")
	if JASAO.result != null:
		if JASAO.result['drinks'] != null:
			SET_POOR_DRINK_VIEW(JASAO, [$GridContainer/First_letter_searched_view/VBoxContainer/GridContainer])
		else:
			for z in $GridContainer/First_letter_selector/HBoxContainer/GridContainer.get_children():
				if z.get_modulate() == Color(0.937255, 0.423529, 0):
					$GridContainer/Searched.text = 'There are no drinks with first letter: ' + z.name
	self.emit_signal("SEARCH_BY_FIRST_LETTER_TASK_COMPLETED")

func GET_DRINK_BY_ID(id, where_to_add: Array):
	$MEGA_REQUESTER.request("https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i="+id)
	yield($MEGA_REQUESTER, "request_completed")
	if JASAO.result != null:
		if JASAO.result['drinks'] != null:
			SET_POOR_DRINK_VIEW(JASAO, where_to_add)
	self.emit_signal("TASK_COMPLETED")

func _process(_delta):
	
	$GridContainer/MORE/VBoxContainer/GridContainer/GridContainer2/VOLUME_NUM.text = str(Global.VOLUME+5)
	
	if Global.VOLUME == -5:
		$GridContainer/MORE/VBoxContainer/GridContainer/GridContainer2/minus.disabled = true
		$GridContainer/MORE/VBoxContainer/GridContainer/GridContainer2/plus.disabled = false
	else:
		$GridContainer/MORE/VBoxContainer/GridContainer/GridContainer2/minus.disabled = false
	if Global.VOLUME == 5:
		$GridContainer/MORE/VBoxContainer/GridContainer/GridContainer2/plus.disabled = true
		$GridContainer/MORE/VBoxContainer/GridContainer/GridContainer2/minus.disabled = false
	else:
		$GridContainer/MORE/VBoxContainer/GridContainer/GridContainer2/plus.disabled = false
	
	#SEE RICH INGREDIENTS DETAILS
	
	var all_widgets = [$GridContainer/MORE, $GridContainer/DISCOVER_TAB,$GridContainer/Searched,$GridContainer/First_letter_searched_view,$GridContainer/First_letter_selector, $GridContainer/FAVORITES]
	
	if current_screen == 'DISCOVER':
		var a = [$GridContainer/DISCOVER_TAB]
		for z in len(all_widgets):
			if all_widgets[z] in a:
				all_widgets[z].visible = true
			else:
				all_widgets[z].visible = false
	elif current_screen == 'COCKTAILS':
		var a = [$GridContainer/Searched,$GridContainer/First_letter_searched_view,$GridContainer/First_letter_selector]
		for z in len(all_widgets):
			if all_widgets[z] in a:
				all_widgets[z].visible = true
			else:
				all_widgets[z].visible = false
	elif current_screen == 'FAVORITES':
		var a = [$GridContainer/FAVORITES]
		for z in len(all_widgets):
			if all_widgets[z] in a:
				all_widgets[z].visible = true
			else:
				all_widgets[z].visible = false
	elif current_screen == 'MORE':
		var a = [$GridContainer/MORE]
		for z in len(all_widgets):
			if all_widgets[z] in a:
				all_widgets[z].visible = true
			else:
				all_widgets[z].visible = false
	
	if len(TO_DO) != 0 and analising == false:
		ANALYSE()

func SET_RICH_DRINK_VIEW(idDrink, strIngredients, strMeasures, strGlass, texture, strDrink, strAlcoholic, strInstructions):
	actual_rich_drink_view = idDrink
	for x in $RICH_DRINK_VIEW/A/ScrollContainer/VBoxContainer/RICH_DRINK_INFOS/INGREDIENTS/ALL_INGREDIENTS.get_children():
		x.free()
	
	for _z in range(0, (len(strIngredients) - len(strMeasures))):
		strMeasures.append('')
	
	for y in len(strIngredients):
		var node = load("res://Scenes/Poor_ingredient_view.tscn").instance()
		node.IngName = strIngredients[y]
		node.IngMeasure = strMeasures[y]
		node.IngImage = 'https://www.thecocktaildb.com/images/ingredients/'+strIngredients[y]+'-Small.png'
		$RICH_DRINK_VIEW/A/ScrollContainer/VBoxContainer/RICH_DRINK_INFOS/INGREDIENTS/ALL_INGREDIENTS.add_child(node)
	
	$RICH_DRINK_VIEW/A/ScrollContainer/VBoxContainer/RICH_DRINK_INFOS/GLASS/Glass_name.text = strGlass
	$RICH_DRINK_VIEW/A/ScrollContainer/VBoxContainer/RICH_DRINK_INFOS/HEADER/IMAGE.texture = texture
	$RICH_DRINK_VIEW/A/ScrollContainer/VBoxContainer/RICH_DRINK_INFOS/HEADER/PRIMARY_INFOS/GridContainer/NAME.text = strDrink
	if strAlcoholic == 'Alcoholic':
		$RICH_DRINK_VIEW/A/ScrollContainer/VBoxContainer/RICH_DRINK_INFOS/HEADER/PRIMARY_INFOS/IS_ALCOHOLIC/TextureRect.set_texture(load("res://Icons/YES.png"))
	else:
		$RICH_DRINK_VIEW/A/ScrollContainer/VBoxContainer/RICH_DRINK_INFOS/HEADER/PRIMARY_INFOS/IS_ALCOHOLIC/TextureRect.set_texture(load("res://Icons/NO.png"))
	var arraia = strInstructions.split('. ')
	$RICH_DRINK_VIEW/A/ScrollContainer/VBoxContainer/RICH_DRINK_INFOS/INSTRUCTIONS/TextEdit.text = ''
	for x in len(arraia):
		$RICH_DRINK_VIEW/A/ScrollContainer/VBoxContainer/RICH_DRINK_INFOS/INSTRUCTIONS/TextEdit.text += arraia[x]
		if x != len(arraia)-1:
			$RICH_DRINK_VIEW/A/ScrollContainer/VBoxContainer/RICH_DRINK_INFOS/INSTRUCTIONS/TextEdit.text += '\n'
	
	$AnimationPlayer.play("SEE_RICH_DRINK_VIEW")

func SEE_RICH_INGREDIENT_VIEW():
	for z in $RICH_DRINK_VIEW/A/ScrollContainer/VBoxContainer/RICH_DRINK_INFOS/INGREDIENTS/ALL_INGREDIENTS.get_children():
		if z.SHOW == true:
			z.SHOW = false
			for x in $RICH_INGREDIENTS_VIEW/A/ScrollContainer/VBoxContainer/RICH_INGREDIENT_INFOS/DRINKS_WITH_THIS_INGREDIENT/ALL_DRINKS_WITH_THIS_INGREDIENT.get_children():
				x.free()
			$RICH_INGREDIENTS_VIEW/A/ScrollContainer/VBoxContainer/RICH_INGREDIENT_INFOS/HEADER/IMAGE.texture= z.find_node("Ingredient_img").texture
			
			$RICH_INGREDIENTS_VIEW/A/ScrollContainer/VBoxContainer/RICH_INGREDIENT_INFOS/HEADER/NAME.text = z.IngName
			if TO_DO[-1][0] == 'see_rich_ingredient_info' and len(TO_DO) > 1:
				TO_DO[-1][1] = z.IngName
			else:
				if len(TO_DO) >= 2:
					TO_DO.insert(1, ['see_rich_ingredient_info', z.IngName])
				else:
					TO_DO.append(['see_rich_ingredient_info', z.IngName])
			
			$AnimationPlayer.play("SEE_RICH_INGREDIENT_VIEW")



func SET_POOR_DRINK_VIEW(json, where:Array):
	for y in where:
		for z in json.result['drinks']:
			var node = preload("res://Scenes/Poor_drink_view.tscn").instance()
			node.idDrink = z['idDrink']
			node.strDrink = z['strDrink']
			node.strAlcoholic = z['strAlcoholic']
			node.strGlass = z['strGlass']
			node.strInstructions = z['strInstructions']
			node.strDrinkThumb = z['strDrinkThumb']
			for x in range(0, 15):
				if z['strIngredient'+str(x+1)] != null:
					node.strIngredients.append(z['strIngredient'+str(x+1)])
			for x in range(0, 15):
				if z['strMeasure'+str(x+1)] != null:
					node.strMeasures.append(z['strMeasure'+str(x+1)])
			y.call_deferred("add_child", node)

func SEE_ALL_FAVORITES():
	for z in $GridContainer/FAVORITES/VBoxContainer/GridContainer.get_children():
		z.free()
	if len(Global.USERS_FAVORITE_DRINKS) == 0:
		$GridContainer/FAVORITES/VBoxContainer/Label.text = "You didn't favorite any drink yet"
	else:
		$GridContainer/FAVORITES/VBoxContainer/Label.text = "Your's favorite drinks"
		for z in Global.USERS_FAVORITE_DRINKS:
			GET_DRINK_BY_ID(z, [$GridContainer/FAVORITES/VBoxContainer/GridContainer])
			yield(self, "TASK_COMPLETED")
	self.emit_signal("SEE_ALL_FAVORITES_TASK_COMPLETED")

func SEE_RICH_INGREDIENT_INFO(ARRA: Array):
	$MEGA_REQUESTER.request('https://www.thecocktaildb.com/api/json/v1/1/filter.php?i='+ARRA[0])
	yield($MEGA_REQUESTER, "request_completed")
	for z in $RICH_INGREDIENTS_VIEW/A/ScrollContainer/VBoxContainer/RICH_INGREDIENT_INFOS/DRINKS_WITH_THIS_INGREDIENT/ALL_DRINKS_WITH_THIS_INGREDIENT.get_children():
		z.free()
	$RICH_INGREDIENTS_VIEW/A/ScrollContainer/VBoxContainer/RICH_INGREDIENT_INFOS/HEADER/IMAGE.texture = ARRA[1]
	
	$RICH_INGREDIENTS_VIEW/A/ScrollContainer/VBoxContainer/RICH_INGREDIENT_INFOS/HEADER/NAME.text = ARRA[0]
	$AnimationPlayer.play("SEE_RICH_INGREDIENT_VIEW")
	for z in JASAO.result['drinks']:
		GET_DRINK_BY_ID(z['idDrink'], [$RICH_INGREDIENTS_VIEW/A/ScrollContainer/VBoxContainer/RICH_INGREDIENT_INFOS/DRINKS_WITH_THIS_INGREDIENT/ALL_DRINKS_WITH_THIS_INGREDIENT])
		yield(self, "TASK_COMPLETED")
	self.emit_signal("SEE_RICH_INGREDIENT_INFO_TASK_COMPLETED")

#idDrink = ID do drink14
#strDrink = nome do drink
#strAlcoholic = se é alcólico ou não
#strGlass = copo que deve ser servido
#strInstructions = instruções de como preparar (em inglês)
#strDrinkThumb = imagem do drink (+/preview pega uma imagem igual com tamanho menor)
#strIndredientX (X = num, num até 15) = ingredientes do drink
#strMeasureX (X = num, num até 15) = quantidade dos ingredientes dos drinks
func _on_DISCOVER_button_up():
	current_screen = 'DISCOVER'
	$GridContainer/THE_FOUR/DISCOVER.set_modulate(Color(0.937255, 0.423529, 0))
	$GridContainer/THE_FOUR/COCKTAILS.set_modulate(Color(1, 1, 1))
	$GridContainer/THE_FOUR/ASSISTANT.set_modulate(Color(1, 1, 1))
	$GridContainer/THE_FOUR/MORE.set_modulate(Color(1, 1, 1))
	if $SEE.visible == true:
		$AnimationPlayer.play("NOT_SEE")
func _on_COCKTAILS_button_up():
	current_screen = 'COCKTAILS'
	$GridContainer/THE_FOUR/DISCOVER.set_modulate(Color(1, 1, 1))
	$GridContainer/THE_FOUR/COCKTAILS.set_modulate(Color(0.937255, 0.423529, 0))
	$GridContainer/THE_FOUR/ASSISTANT.set_modulate(Color(1, 1, 1))
	$GridContainer/THE_FOUR/MORE.set_modulate(Color(1, 1, 1))
	if $SEE.visible == true:
		$AnimationPlayer.play("NOT_SEE")
func _on_ASSISTANT_button_up():
	current_screen = 'FAVORITES'
	$GridContainer/THE_FOUR/DISCOVER.set_modulate(Color(1, 1, 1))
	$GridContainer/THE_FOUR/COCKTAILS.set_modulate(Color(1, 1, 1))
	$GridContainer/THE_FOUR/ASSISTANT.set_modulate(Color(0.937255, 0.423529, 0))
	$GridContainer/THE_FOUR/MORE.set_modulate(Color(1, 1, 1))
	if $SEE.visible == true:
		$AnimationPlayer.play("NOT_SEE")
	SEE_THAT('see_all_favorites')
func _on_MORE_button_up():
	current_screen = 'MORE'
	$GridContainer/THE_FOUR/DISCOVER.set_modulate(Color(1, 1, 1))
	$GridContainer/THE_FOUR/COCKTAILS.set_modulate(Color(1, 1, 1))
	$GridContainer/THE_FOUR/ASSISTANT.set_modulate(Color(1, 1, 1))
	$GridContainer/THE_FOUR/MORE.set_modulate(Color(0.937255, 0.423529, 0))
	if $SEE.visible == true:
		$AnimationPlayer.play("NOT_SEE")

func LETTER(letter, what:String = 'search_by_first_letter'):
	if len(TO_DO) != 0:
		if TO_DO[-1][0] == what and len(TO_DO) > 1:
			TO_DO[-1][1] = letter
		else:
			if len(TO_DO) >= 2:
				TO_DO.insert(1, [what, letter])
			else:
				TO_DO.append([what, letter])
	else:
		if len(TO_DO) >= 2:
			TO_DO.insert(1, [what, letter])
		else:
			TO_DO.append([what, letter])

func _on_a_button_up():
	LETTER('a')
func _on_b_button_up():
	LETTER('b')
func _on_c_button_up():
	LETTER('c')
func _on_d_button_up():
	LETTER('d')
func _on_e_button_up():
	LETTER('e')
func _on_f_button_up():
	LETTER('f')
func _on_g_button_up():
	LETTER('g')
func _on_h_button_up():
	LETTER('h')
func _on_i_button_up():
	LETTER('i')
func _on_j_button_up():
	LETTER('j')
func _on_k_button_up():
	LETTER('k')
func _on_l_button_up():
	LETTER('l')
func _on_m_button_up():
	LETTER('m')
func _on_n_button_up():
	LETTER('n')
func _on_o_button_up():
	LETTER('o')
func _on_p_button_up():
	LETTER('p')
func _on_q_button_up():
	LETTER('q')
func _on_r_button_up():
	LETTER('r')
func _on_s_button_up():
	LETTER('s')
func _on_t_button_up():
	LETTER('t')
func _on_u_button_up():
	LETTER('u')
func _on_v_button_up():
	LETTER('v')
func _on_w_button_up():
	LETTER('w')
func _on_x_button_up():
	LETTER('x')
func _on_y_button_up():
	LETTER('y')
func _on_z_button_up():
	LETTER('z')

func SEE_THAT(what:String):
	if len(TO_DO) > 1:
		if TO_DO[-1][0] != what:
			if len(TO_DO) >= 2:
				TO_DO.insert(1, [what])
			else:
				TO_DO.append([what])
	else:
		if len(TO_DO) >= 2:
			TO_DO.insert(1, [what])
		else:
			TO_DO.append([what])

func _on_SEE_ANOTHER_RANDOM_COCKTAIL_button_up():
	for z in $GridContainer/DISCOVER_TAB/VBoxContainer/THE_RANDOM_COCKTAIL.get_children():
		z.free()
	$GridContainer/DISCOVER_TAB/VBoxContainer/THE_RANDOM_COCKTAIL.add_child(preload("res://Scenes/LOADING_ANIMATION.tscn").instance())
	SEE_THAT('show_random_cocktail')

func _on_SEE_ALL_ALCOHOLICS_button_up():
	SEE_THAT('show_alcoholic_drinks')
	$AnimationPlayer.play("SEE")
	$SEE/A/SEE_ALCOHOLIC_DRINKS.visible = true

func _on_SEE_ALL_NON_ALCOHOLICS_button_up():
	SEE_THAT('show_non_alcoholic_drinks')
	$AnimationPlayer.play("SEE")
	$SEE/A/SEE_NON_ALCOHOLIC_DRINKS.visible = true

func _on_RETURN_alcoholic_drinks_button_up():
	$AnimationPlayer.play("NOT_SEE")
	yield($AnimationPlayer, "animation_finished")
	$SEE/A/SEE_ALCOHOLIC_DRINKS.visible = false

func _on_RETURN_non_alcoholic_drinks_button_up():
	$AnimationPlayer.play("NOT_SEE")
	yield($AnimationPlayer, "animation_finished")
	$SEE/A/SEE_NON_ALCOHOLIC_DRINKS.visible = false

func _on_RETURN_glass_button_up():
	$AnimationPlayer.play("NOT_SEE")
	yield($AnimationPlayer, "animation_finished")
	$SEE/A/SEE_ALL_GLASS.visible = false
	$SEE/A/SEE_ALL_GLASS/ScrollContainer/VBoxContainer/GLASS.visible = true
	$SEE/A/SEE_ALL_GLASS/ScrollContainer/VBoxContainer/DRINKS.visible = false

func _on_RETURN_categories_button_up():
	$AnimationPlayer.play("NOT_SEE")
	yield($AnimationPlayer, "animation_finished")
	$SEE/A/SEE_ALL_CATEGORIES.visible = false
	$SEE/A/SEE_ALL_CATEGORIES/ScrollContainer/VBoxContainer/CATEGORIES.visible = true
	$SEE/A/SEE_ALL_CATEGORIES/ScrollContainer/VBoxContainer/DRINKS.visible = false

func _on_SEE_ALL_CATEGORIES_button_up():
	$AnimationPlayer.play("SEE")
	$SEE/A/SEE_ALL_CATEGORIES.visible = true
	$SEE/A/SEE_ALL_CATEGORIES/ScrollContainer/VBoxContainer/CATEGORIES.visible = true
	$SEE/A/SEE_ALL_CATEGORIES/ScrollContainer/VBoxContainer/DRINKS.visible = false

func _on_SEE_ALL_GLASS_button_up():
	$AnimationPlayer.play("SEE")
	$SEE/A/SEE_ALL_GLASS.visible = true
	$SEE/A/SEE_ALL_GLASS/ScrollContainer/VBoxContainer/GLASS.visible = true
	$SEE/A/SEE_ALL_GLASS/ScrollContainer/VBoxContainer/DRINKS.visible = false

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_MEGA_REQUESTER_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	JASAO = json

func ANALYSE():
	analising = true
	if TO_DO[0][0] == 'search_by_first_letter':
		SEARCH_BY_FIRST_LETTER(TO_DO[0][1])
		yield(self, "SEARCH_BY_FIRST_LETTER_TASK_COMPLETED")
		TO_DO.pop_front()
	elif TO_DO[0][0] == 'show_random_cocktail':
		SHOW_RANDOM_COCKTAIL()
		yield(self, "SHOW_RANDOM_COCKTAIL_TASK_COMPLETED")
		TO_DO.pop_front()
	elif TO_DO[0][0] == 'show_alcoholic_drinks':
		SHOW_ALCOHOLIC_DRINKS()
		yield(self, "SHOW_ALCOHOLIC_DRINKS_TASK_COMPLETED")
		TO_DO.pop_front()
	elif TO_DO[0][0] == 'show_non_alcoholic_drinks':
		SHOW_NON_ALCOHOLIC_DRINKS()
		yield(self, "SHOW_NON_ALCOHOLIC_DRINKS_TASK_COMPLETED")
		TO_DO.pop_front()
	elif TO_DO[0][0] == 'show_drinks_by_glass':
		SHOW_DRINKS_BY_GLASS(TO_DO[0][1])
		yield(self, "SHOW_DRINKS_BY_GLASS_TASK_COMPLETED")
		TO_DO.pop_front()
	elif TO_DO[0][0] == 'show_drinks_by_categories':
		SHOW_DRINKS_BY_CATEGORIES(TO_DO[0][1])
		yield(self, "SHOW_DRINKS_BY_CATEGORIES_TASK_COMPLETED")
		TO_DO.pop_front()
	elif TO_DO[0][0] == 'see_all_categories':
		SEE_ALL_CATEGORIES()
		yield(self, "SEE_ALL_CATEGORIES_TASK_COMPLETED")
		TO_DO.pop_front()
	elif TO_DO[0][0] == 'see_all_ingredients':
		SEE_ALL_INGREDIENTS()
		yield(self, "SEE_ALL_INGREDIENTS_TASK_COMPLETED")
		TO_DO.pop_front()
	elif TO_DO[0][0] == 'see_all_glass':
		SEE_ALL_GLASS()
		yield(self, "SEE_ALL_GLASS_TASK_COMPLETED")
		TO_DO.pop_front()
	elif TO_DO[0][0] == 'see_all_favorites':
		SEE_ALL_FAVORITES()
		yield(self, "SEE_ALL_FAVORITES_TASK_COMPLETED")
		TO_DO.pop_front()
	elif TO_DO[0][0] == 'see_rich_ingredient_info':
		SEE_RICH_INGREDIENT_INFO(TO_DO[0][1])
		yield(self, "SEE_RICH_INGREDIENT_INFO_TASK_COMPLETED")
		TO_DO.pop_front()
	analising = false

func _on_FAVORITE_button_up():
	if actual_rich_drink_view in Global.USERS_FAVORITE_DRINKS:
		Global.USERS_FAVORITE_DRINKS.remove(Global.USERS_FAVORITE_DRINKS.find(actual_rich_drink_view))
	else:
		Global.USERS_FAVORITE_DRINKS.append(actual_rich_drink_view)
	Global.SAVE()

func _on_RETURN_rich_drink_view_button_up():
	$AnimationPlayer.play("NOT_SEE_RICH_DRINK_VIEW")

func _on_RETURN_rich_ingredient_view_button_up():
	$AnimationPlayer.play("NOT_SEE_RICH_INGREDIENT_VIEW")

func _on_Timer_timeout():
	MobileAds.load_rewarded_interstitial()
	MobileAds.show_rewarded()

func _on_minus_button_up():
	Global.VOLUME -= 1
	AudioServer.set_bus_volume_db(1, Global.VOLUME)

func _on_plus_button_up():
	Global.VOLUME += 1
	AudioServer.set_bus_volume_db(1, Global.VOLUME)

func _on_CheckBox_toggled(button_pressed):
	if button_pressed == true:
		Global.MUSIC = true
	else:
		Global.MUSIC = false
	Global.SAVE()
