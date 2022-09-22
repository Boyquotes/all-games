extends Node2D

var x = 0
var y = 0

var size = 32

var control = false

var origin_position = Vector2.ZERO
#['tipo', 'quantas em int']]
var nome = []
var quantidade = []
var killed = false

func obj_reset():
	visible = false
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	set_process(false)

func obj_set():
	Global.SET_RANDOM_ITEM(self)
	origin_position = global_position
	$Button.set_size(Vector2(size, size))
	x = Global.RANDOM.randf_range(-1, 1)
	y = Global.RANDOM.randf_range(-1, 1)
	visible = true
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
	set_process(true)
	killed = false

func _ready():
	obj_set()

func _process(_delta):
	if control:
		global_position = get_global_mouse_position()
	else:
		rotation_degrees += 2 * Global.PLAYER_INFOS['multiplicador']
		global_position = Vector2(global_position[0]+x * Global.PLAYER_INFOS['multiplicador'], global_position[1]+y * Global.PLAYER_INFOS['multiplicador'])
		if origin_position.distance_to(global_position) > 5000:
			ObjectPoolManager.destroy(self.get_instance_id())

func _on_Button_button_down():
	control = true

func _on_Button_button_up():
	control = false

func _on_Area2D_area_entered(area):
	area = area.get_parent()
	if area.is_in_group("Planet") and control == false and area.find_node('TextureButton').pressed == false and killed == false:
		area.INFOS['exp'] += 1
		area.find_node('ProgressBar').value = area.INFOS['exp']
		area.find_node('ProgressBar').visible = true
		Global.KILL(self)
		killed = true
	if area.is_in_group("Asteroid") and control == false and area.control == false and killed == false:
		Global.KILL(self)
		killed = true
