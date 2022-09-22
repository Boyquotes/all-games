extends Node2D

const TEXTURES = {
	'Kate': "res://Images/Chars/KATE-NORMAL.png",
	'Ian': "res://Images/Chars/MAIN-NORMAL.png",
}

var dialogo = ''

func _enter_tree():
	add_user_signal('dialog_finished', [])
	get_tree().paused = true
	Global.set_process_bit(self, false)
	START_DIALOG(dialogo)
	yield(self, "dialog_finished")
	get_tree().paused = false
	get_tree().get_nodes_in_group("PLAYER")[0].get_node("Camera2D").current = true
	queue_free()

func START_DIALOG(dialog):
	for z in AllDialogs.DIALOGS[dialog]:
		RUN_DIALOG(z[0], z[1])
		yield($Continue, "button_up")
	emit_signal("dialog_finished")

func RUN_DIALOG(text: String, character: String = '') -> void:
	$Label.text = text
	$Continue.visible = false
	$TextureRect.texture = load(TEXTURES[character])
	$Continue.visible = true
