extends Node2D

#var a = 'Abacate. abobora. banana. cenoura. laranja'

#func _ready():
#	var arraia = a.split('. ')
#	for z in arraia:
#		print(str(z))

#USE THIS TO SHOW THE INSTRUCTIONS FOR THE USER


const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db #database object
var db_name = "res://Database/FAVORITES" #path to db

func _ready():
	db = SQLite.new()
	db.path = db_name
	$Label.text = str(db.open_db())
#	var new_save = load("res://Database/FAVORITES").new()
#	
# warning-ignore:return_value_discarded
#	ResourceSaver.save("user://FAVORITES.db", new_save)

func commitDataToDB(ID):
	db.open_db()
	var dict: Dictionary = Dictionary()
	dict['id'] = ID
	db.insert_row("FAVORITES", dict)

func removeDataToDB(ID):
	db.open_db()
	var string = "DELETE FROM FAVORITES WHERE FAVORITES.id = "+str(ID)+";"
	db.query(string)

func readFromDB():
	db.open_db()
	db.query("SELECT * FROM FAVORITES;")
	$Label.text = ''
	for z in db.query_result:
		print(z['id'])
		$Label.text += str(z['id'])
		$Label.text += '\n'


func _on_ADD_button_up():
	commitDataToDB($AD.value)

func _on_REMOVE_button_up():
	removeDataToDB($RE.value)

func _on_SHOW_button_up():
	readFromDB()
