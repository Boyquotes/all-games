extends TextureButton

export(String) var TYPE

#MAPA
#COMPRAR
#CRAFT/BUILD
#VENDER
#ESTATISTICAS

func _ready():
	if TYPE == 'MAPA':
		$".".set_normal_texture(load("res://Images/ICONES_DE_JOGABILIDADE/MAPA.png"))
		$".".set_pressed_texture(load("res://Images/ICONES_DE_JOGABILIDADE/MAPA-PRESSED.png"))
	if TYPE == 'COMPRAR':
		$".".set_normal_texture(load("res://Images/ICONES_DE_JOGABILIDADE/CESTA.png"))
		$".".set_pressed_texture(load("res://Images/ICONES_DE_JOGABILIDADE/CESTA-PRESSED.png"))
	if TYPE == 'CRAFT':
		$".".set_normal_texture(load("res://Images/ICONES_DE_JOGABILIDADE/MARTELO.png"))
		$".".set_pressed_texture(load("res://Images/ICONES_DE_JOGABILIDADE/MARTELO-PRESSED.png"))
	if TYPE == 'VENDER':
		$".".set_normal_texture(load("res://Images/ICONES_DE_JOGABILIDADE/SIFRAO.png"))
		$".".set_pressed_texture(load("res://Images/ICONES_DE_JOGABILIDADE/SIFRAO-PRESSED.png"))
	if TYPE == 'ESTATISTICAS':
		$".".set_normal_texture(load("res://Images/ICONES_DE_JOGABILIDADE/PLAYER.png"))
		$".".set_pressed_texture(load("res://Images/ICONES_DE_JOGABILIDADE/PLAYER-PRESSED.png"))

func _on_TOOLBAR_BUTTON_button_up():
	get_tree().get_nodes_in_group("GAME")[0].emit_signal("TOOLBAR_BUTTON_PRESSED", TYPE)
