extends Node2D
#[scene, shoot_delay]
var TYPE = []

var textures = {
	"res://Scenes/Special_bullets/2-DISPERSOR.tscn": "res://Images/Special_weapons/0.png", 
	"res://Scenes/Special_bullets/4-DISPERSOR.tscn": "res://Images/Special_weapons/0.png", 
	"res://Scenes/Special_bullets/8-DISPERSOR.tscn": "res://Images/Special_weapons/0.png", 
	"res://Scenes/Special_bullets/BIG.tscn": "res://Images/Special_weapons/0.png",
}

func _ready():
	$IMG.texture = load(textures[TYPE[0]])
	$IMG.set_rotation_degrees(randi()%360)

func _on_PICK_button_up():
	Global.PLAYER_INFOS['special_bullet'] = TYPE
	get_tree().get_nodes_in_group("PLAYER")[0].find_node("Sprite").find_node("Special_weapon").texture = load(textures[TYPE[0]])
	get_tree().get_nodes_in_group("PLAYER")[0].can_fire_special = true
	queue_free()

func _on_Area2D_area_entered(area):
	if area.get_parent().get_parent().is_in_group("PLAYER"):
		$PICK.visible = !$PICK.visible

func _on_Area2D_area_exited(area):
	if area.get_parent().get_parent().is_in_group("PLAYER"):
		$PICK.visible = !$PICK.visible
