extends Node2D

var game_save_class: Script = load("res://Scripts/Game_save_class.gd")

var MUSIC = true
var VOLUME = 0

var USERS_FAVORITE_DRINKS = []

func SET_BANNER():
	if MobileAds.get_is_initialized():
		var item_text : String = 'FULL_BANNER'
		MobileAds.config.banner.size = item_text
		if MobileAds.get_is_banner_loaded():
			MobileAds.load_banner()

func _ready():
	SAVE()
	LOAD()
	SET_BANNER()

func SAVE():
	var new_save = game_save_class.new()
	new_save.FAVORITE_DRINKS = USERS_FAVORITE_DRINKS
	new_save.MUSIC = MUSIC
	new_save.VOLUME = VOLUME
	
# warning-ignore:return_value_discarded
	ResourceSaver.save("user://game_save.tres", new_save)

func LOAD():
	var dir = Directory.new()
	if not dir.file_exists("user://game_save.tres"):
		return false
	
	var saved_game = load("user://game_save.tres")
	
	for z in saved_game.FAVORITE_DRINKS:
		USERS_FAVORITE_DRINKS.append(z)
	
	MUSIC = saved_game.MUSIC
	VOLUME = saved_game.VOLUME
	AudioServer.set_bus_volume_db(1, VOLUME)
	
	return true
