extends Node2D

var JsonContent

func _ready():
	Global.set_process_bit(self, false)

func SetQuestion(idx):
	$"Questão".Clear()
	$"Questão".Add("Enunciado", JsonContent[idx][0])
	for z in JsonContent[idx][1]:
		$"Questão".Add("Imagem", z)
	for z in JsonContent[idx][2]:
		$"Questão".Add("Alternativa", z)
	$"Questão".Add("Resposta", JsonContent[idx][3])
	$"Questão".visible = true

func _on_FileDialog_file_selected(path):
	var file = File.new()
	file.open(path, file.READ)
	var json = file.get_as_text()
	JsonContent = parse_json(json)
	file.close()
	SetQuestion(0)
	$Button.queue_free()
	$FileDialog.queue_free()

func _on_Button_button_up():
	$FileDialog.set_current_dir('C:/Users/USER/Desktop/ProjetoQuestões')
	$FileDialog.popup()
