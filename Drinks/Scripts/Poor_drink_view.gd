extends GridContainer
export(int) var idDrink
export(String) var strDrink
export(String) var strAlcoholic
export(String) var strGlass
export(String) var strInstructions
export(String) var strDrinkThumb #é a imagem thumbnail do drink
export(Array) var strIngredients
export(Array) var strMeasures
func _ready():
	$Drink_name.text = strDrink
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")
	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	http_request.request(strDrinkThumb+'/preview')
	if idDrink in Global.USERS_FAVORITE_DRINKS:
		$Drink_img/FAVORITE.pressed = true
# Called when the HTTP request is completed.
func _http_request_completed(_result, _response_code, _headers, body):
	var image = Image.new()
	image.load_jpg_from_buffer(body)
	var buffer = image.save_png_to_buffer()
	var texture = Image.new()
	texture.load_png_from_buffer(buffer)
	var imagetexture = ImageTexture.new()
	imagetexture.create_from_image(texture)
	$Drink_img.texture = imagetexture
func _on_See_more_informations_button_up():
	get_tree().get_nodes_in_group("MAIN")[0].SET_RICH_DRINK_VIEW(idDrink, strIngredients, strMeasures, strGlass, $Drink_img.texture, strDrink, strAlcoholic, strInstructions)

func _on_FAVORITE_button_up():
	if idDrink in Global.USERS_FAVORITE_DRINKS:
		Global.USERS_FAVORITE_DRINKS.remove(Global.USERS_FAVORITE_DRINKS.find(idDrink))
	else:
		Global.USERS_FAVORITE_DRINKS.append(idDrink)
	Global.SAVE()
