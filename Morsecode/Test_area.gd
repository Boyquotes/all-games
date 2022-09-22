extends Node2D

func _ready():
	print(OS.shell_open('www.thecocktaildb.com/api/json/v1/1/search.php?f=a'))


