extends Node2D

#O que eu quero?
#sistema que organiza automaticamente os horários dos professores

#BASE DE DADOS? - sim, vamos tentar com SQL?
#Acho que não precisa ser uma base de dados, acho que apenas adicionando no método padrão para games (save_game do cocktail pro)

#PROFESSOR = {
#	'horarios que nao quer/não pode' = [lista com os horários]
#	'horários que quer/prefere' = [lista com os horários]
#}

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db #database object
var db_name = "res://DataStore/database" #path to db

func _ready():
	db = SQLite.new()
	db.path = db_name
	commitDataToDB()
	readFromDB()


func commitDataToDB():
	db.open_db()
	var tableName = "ABACATE"
	var dict: Dictionary = Dictionary()
	dict['Nome'] = "BIRIBI?"
	
	db.insert_row(tableName, dict)

func readFromDB():
	db.open_db()
	var tableName = "ABACATE"
	db.query("select * from "+tableName+";")
	for z in db.query_result:
		print(z)




