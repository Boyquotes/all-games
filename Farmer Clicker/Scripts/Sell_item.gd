extends GridContainer

var ITEM #item que está sendo vendido
var ESTACAO: String

func _ready():
	
	if ITEM in Global.ALL_PLANTS_LIST:
		for z in Global.ESTACAO:
			for x in Global.ESTACAO[z]:
				if x == ITEM:
					ESTACAO = z
					break
					break
		$GridContainer/TextureRect3.texture = load(Global.TEXTURES[ESTACAO])
	$GridContainer2/Label.text = Global.TEXT[Global.LANGUAGE]['Planta']
	$GridContainer2/Label2.text = Global.TEXT[Global.LANGUAGE]['Estação']
	$GridContainer2/Label4.text = Global.TEXT[Global.LANGUAGE]['Valor']
	$GridContainer/TextureRect2.texture = load(Global.TEXTURES[ITEM])
	$HSlider.max_value = Global.INVENTORY[ITEM]

func _process(_delta):
	if Global.INVENTORY['estacao_atual'] == ESTACAO:
		$GridContainer/Label.text = str(($HSlider.value*Global.BASE_PRICES[ITEM])*0.5)
	else:
		$GridContainer/Label.text = str(($HSlider.value*Global.BASE_PRICES[ITEM])*1.5)

func _on_Button_button_up():
	Global.INVENTORY[ITEM] -= $HSlider.value
	Global.INVENTORY['money'] += int($GridContainer/Label.text)
	$HSlider.value = 0
	$HSlider.max_value = Global.INVENTORY[ITEM]
	if Global.INVENTORY[ITEM] == 0:
		queue_free()
