extends Node2D

onready var PLAYER = get_tree().get_nodes_in_group("PLAYER")[0]

var posi = Vector2.ZERO
var need_to_move = false

func _ready():
	$Progress.max_value = Global.INTERESTELAR_INFOS['max_health']
	$Progress.value = Global.INTERESTELAR_INFOS['max_health']
	Global.INTERESTELAR_INFOS['actual_health'] = Global.INTERESTELAR_INFOS['max_health']
	Global.set_process_bit(self, false)
	set_process(true)

func _process(_delta):
	if global_position != posi and need_to_move == true:
		global_position = lerp(global_position, posi, 0.1)
		if abs(global_position[0]-posi[0]) <= 1 and abs(global_position[1]-posi[1]) <= 1:
			need_to_move = false
		yield(get_tree().create_timer(0.01), "timeout")
	$Autofire.visible = PLAYER.auto_fire
	if PLAYER.pause == true:
		get_tree().paused = !get_tree().paused
		$ESC.visible = !$ESC.visible
		$ESC/RESUME.visible = !$ESC/RESUME.visible
	$Progress.value = Global.INTERESTELAR_INFOS['actual_health']
	if $Progress.value == 0:
		get_tree().paused = true
		$ESC/Label.visible = true
		$ESC.visible = true
		$ESC/RESUME.visible = false
		$ESC/GridContainer.visible = true
		if Global.DEMO == false:
			Global.SALVAR()
			
		for z in Global.BASE_INTERESTELLAR_INFOS:
			Global.INTERESTELLAR_INFOS[z] = Global.BASE_INTERESTELLAR_INFOS[z]

func _on_Options_toggled(button_pressed):
	match button_pressed:
		true:
			$ESC/RESUME.disabled = true
			$ESC/Options.visible = true
		false:
			$ESC/RESUME.disabled = false
			$ESC/Options.visible = false


func _on_RESUME_button_up():
	get_tree().paused = !get_tree().paused
	$ESC.visible = !$ESC.visible
	$ESC/RESUME.visible = !$ESC/RESUME.visible

