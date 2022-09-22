extends ColorRect

onready var INPUT = get_tree().get_nodes_in_group("INPUT")[0]
var TEXT = ''

#Color(0.345098, 0.345098, 0.345098) = #585858
#Color(0, 0.65098, 0.054902)
#Color(0.717647, 0, 0)

func _ready() -> void:
	Global.set_process_bit(self, false)
	TEXT = Global.RETURN_TEXT()
	$Label.text = TEXT
