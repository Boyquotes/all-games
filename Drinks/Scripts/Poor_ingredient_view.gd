extends GridContainer

export(String) var IngImage
export(String) var IngName
export(String) var IngMeasure

func _ready():
	$Ingredient_name_and_measure.text = IngMeasure + ' ' + IngName
	var http_request = HTTPRequest.new()
	http_request.connect("request_completed", self, "_http_request_completed")
	add_child(http_request)
	http_request.request(IngImage)

func _on_See_more_ingredient_informations_button_up():
	get_tree().get_nodes_in_group("MAIN")[0].LETTER([IngName, $Ingredient_img.texture], 'see_rich_ingredient_info')

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _http_request_completed(result, response_code, headers, body):
	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	$Ingredient_img.texture = texture
	if error != OK:
		self.visible = false
