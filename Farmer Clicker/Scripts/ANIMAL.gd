extends Node2D

export(String) var TYPE

const MAX_DISTANCE = 150

func _ready():
	if TYPE == 'BOI':
		$"RABO".set_texture(load("res://Images/ANIMALS/BOI/BOI-RABO.png"))
		$"ESQUERDA-FRENTE".set_texture(load("res://Images/ANIMALS/BOI/BOI-PERNA-ESQUERDA-FRENTE.png"))
		$"ESQUERDA-TRAZ".set_texture(load("res://Images/ANIMALS/BOI/BOI-PERNA-ESQUERDA-TRAZ.png"))
		$"CORPO".set_texture(load("res://Images/ANIMALS/BOI/BOI-CORPO.png"))
		$"DIREITA-TRAZ".set_texture(load("res://Images/ANIMALS/BOI/BOI-PERNA-DIREITA-TRAZ.png"))
		$"DIREITA-FRENTE".set_texture(load("res://Images/ANIMALS/BOI/BOI-PERNA-DIREITA-FRENTE.png"))
		$"CABECA".set_texture(load("res://Images/ANIMALS/BOI/BOI-CABECA.png"))
	if TYPE == 'CABRA':
		$"RABO".set_texture(load("res://Images/ANIMALS/CABRA/CABRA-RABO.png"))
		$"ESQUERDA-FRENTE".set_texture(load("res://Images/ANIMALS/CABRA/CABRA-PERNA-ESQUERDA-FRENTE.png"))
		$"ESQUERDA-TRAZ".set_texture(load("res://Images/ANIMALS/CABRA/CABRA-PERNA-ESQUERDA-TRAZ.png"))
		$"CORPO".set_texture(load("res://Images/ANIMALS/CABRA/CABRA-CORPO.png"))
		$"TETA".set_texture(load("res://Images/ANIMALS/CABRA/CABRA-TETA.png"))
		$"DIREITA-TRAZ".set_texture(load("res://Images/ANIMALS/CABRA/CABRA-PERNA-DIREITA-TRAZ.png"))
		$"DIREITA-FRENTE".set_texture(load("res://Images/ANIMALS/CABRA/CABRA-PERNA-DIREITA-FRENTE.png"))
		$"CABECA".set_texture(load("res://Images/ANIMALS/CABRA/CABRA-CABECA.png"))
	if TYPE == 'GALINHA':
		$"RABO".set_texture(load("res://Images/ANIMALS/GALINHA/GALINHA-PESCOCO.png"))
		$"ESQUERDA-FRENTE".set_texture(load("res://Images/ANIMALS/GALINHA/GALINHA-CRISTA.png"))
		$"ESQUERDA-TRAZ".set_texture(load("res://Images/ANIMALS/GALINHA/GALINHA-PAPO.png"))
		$"CORPO".set_texture(load("res://Images/ANIMALS/GALINHA/GALINHA-CORPO.png"))
		$"DIREITA-TRAZ".set_texture(load("res://Images/ANIMALS/GALINHA/GALINHA-PERNA2.png"))
		$"DIREITA-FRENTE".set_texture(load("res://Images/ANIMALS/GALINHA/GALINHA-PERNA.png"))
		$"CABECA".set_texture(load("res://Images/ANIMALS/GALINHA/GALINHA-CABECA.png"))
	if TYPE == 'OVELHA':
		$"RABO".set_texture(load("res://Images/ANIMALS/OVELHA/OVELHA-RABO.png"))
		$"ESQUERDA-FRENTE".set_texture(load("res://Images/ANIMALS/OVELHA/OVELHA-PERNA-ESQUERDA-FRENTE.png"))
		$"ESQUERDA-TRAZ".set_texture(load("res://Images/ANIMALS/OVELHA/OVELHA-PERNA-ESQUERDA-TRAZ.png"))
		$"CORPO".set_texture(load("res://Images/ANIMALS/OVELHA/OVELHA-CORPO.png"))
		$"DIREITA-TRAZ".set_texture(load("res://Images/ANIMALS/OVELHA/OVELHA-PERNA-DIREITA-TRAZ.png"))
		$"DIREITA-FRENTE".set_texture(load("res://Images/ANIMALS/OVELHA/OVELHA-PERNA-DIREITA-FRENTE.png"))
		$"CABECA".set_texture(load("res://Images/ANIMALS/OVELHA/OVELHA-CABECA.png"))
	if TYPE == 'PORCO':
		$"RABO".set_texture(load("res://Images/ANIMALS/PORCO/PORCO-RABO.png"))
		$"ESQUERDA-FRENTE".set_texture(load("res://Images/ANIMALS/PORCO/PORCO-PERNA-ESQUERDA-FRENTE.png"))
		$"ESQUERDA-TRAZ".set_texture(load("res://Images/ANIMALS/PORCO/PORCO-PERNA-ESQUERDA-TRAZ.png"))
		$"CORPO".set_texture(load("res://Images/ANIMALS/PORCO/PORCO-CORPO.png"))
		$"DIREITA-TRAZ".set_texture(load("res://Images/ANIMALS/PORCO/PORCO-PERNA-DIREITA-TRAZ.png"))
		$"DIREITA-FRENTE".set_texture(load("res://Images/ANIMALS/PORCO/PORCO-PERNA-DIREITA-FRENTE.png"))
		$"CABECA".set_texture(load("res://Images/ANIMALS/PORCO/PORCO-CABECA.png"))
	if TYPE == 'VACA':
		$"RABO".set_texture(load("res://Images/ANIMALS/VACA/VACA-RABO.png"))
		$"ESQUERDA-FRENTE".set_texture(load("res://Images/ANIMALS/VACA/VACA-PERNA-ESQUERDA-FRENTE.png"))
		$"ESQUERDA-TRAZ".set_texture(load("res://Images/ANIMALS/VACA/VACA-PERNA-ESQUERDA-TRAZ.png"))
		$"CORPO".set_texture(load("res://Images/ANIMALS/VACA/VACA-CORPO.png"))
		$"TETA".set_texture(load("res://Images/ANIMALS/VACA/VACA-TETA.png"))
		$"DIREITA-TRAZ".set_texture(load("res://Images/ANIMALS/VACA/VACA-PERNA-DIREITA-TRAZ.png"))
		$"DIREITA-FRENTE".set_texture(load("res://Images/ANIMALS/VACA/VACA-PERNA-DIREITA-FRENTE.png"))
		$"CABECA".set_texture(load("res://Images/ANIMALS/VACA/VACA-CABECA.png"))
	$AnimationPlayer.play(TYPE+"-IDLE")

