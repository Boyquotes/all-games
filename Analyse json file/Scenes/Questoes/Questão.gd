extends GridContainer

var ActualAnswer

var RealAnswer

func Clear():
	$Enunciado.text = ""
	for z in $Imagens/Imagens.get_children():
		z.queue_free()
	for z in $Alternativas/Alternativas.get_children():
		z.queue_free()
	ActualAnswer = null
	RealAnswer = null

func Add(what, content):
	match what:
		"Enunciado":
			$Enunciado.text = content
		"Imagem":
			var image = Image.new()
			image.load(content)
			var t = ImageTexture.new()
			t.create_from_image(image)
			var node = TextureRect.new()
			node.texture = t
			node.set_v_size_flags(3)
			node.set_h_size_flags(3)
			$Imagens/Imagens.add_child(node)
		"Alternativa":
			var node = preload("res://Scenes/Questoes/Alternativa.tscn").instance()
			node.get_child(1).text = content
			$Alternativas/Alternativas.add_child(node)
		"Resposta":
			RealAnswer = content

func SetAnswer(answer):
	ActualAnswer = answer
	for z in $Alternativas/Alternativas.get_children():
		if z.get_child(1).text != answer:
			z.get_child(0).pressed = false

func SubmitAnswer():
	pass
