extends Node2D

func _ready():
	if !Global.musics.is_playing():
		Global.play_sound('main_menu_music')

func _on_Quit_button_up():
	get_tree().quit(1)

func _on_Configurations_button_up():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menus/Configurations.tscn")
	Global.play_sound('button_pressed')

const STANDARD_PLAYER_INFOS = {
	'actual_health': 5, # Vida atual
	'max_health': 5, # Vida máxima
	
	'energy_per_tick': 0.5, # Energia por tick
	'max_energy': 5, # Energia máxima
	'energy': 0, # Dinheiro para posicionar habilidades
	'firewall_points': 0, # Dinheiro da loja
	
	'habilities': ['shield'], # Lista das habilidades que o Player tem |-> Sempre tem o Shield
	'mega_habilities': [], # Lista das mega-habilidades |-> Composição de uma ou mais habilidades para fazer uma mega defesa contra os inimigos
	'positioned_habilities': [], # Lista dos nodes de habilidade que o player colocou
	
	'last_wave': 0, # Última wave que o player estava
	'unlocked_enemies': ['brutus'], # Lista dos inimigos liberados para aparecer nas waves |-> brutus sempre liberado
	
	'prevention_shoot_ticks_delay': 23,
	'wandering_health': 6,
}

func _on_Start_button_up():
	Global.PLAYER_INFOS = STANDARD_PLAYER_INFOS
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Dialogs/InnitialConversation.tscn")
	Global.play_sound('button_pressed')

func _on_AboutTheDevs_button_up():
# warning-ignore:return_value_discarded
	OS.shell_open('https://canova-games.web.app/')
	Global.play_sound('button_pressed')
