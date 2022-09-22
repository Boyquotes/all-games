extends Node2D

func _ready():
	Global.set_process_bit(self, false)
	set_process(true)

func _process(_delta):
	if Input.is_action_just_pressed("D") and AudioServer.get_bus_volume_db(0) > -10:
		AudioServer.set_bus_volume_db(0, AudioServer.get_bus_volume_db(0)-1)
		$AnimationPlayer.stop()
		$AnimationPlayer.play("Run")
		$Label.text = str(AudioServer.get_bus_volume_db(0)+10)
	if Input.is_action_just_pressed("A") and AudioServer.get_bus_volume_db(0) < 10:
		AudioServer.set_bus_volume_db(0, AudioServer.get_bus_volume_db(0)+1)
		$AnimationPlayer.stop()
		$AnimationPlayer.play("Run")
		$Label.text = str(AudioServer.get_bus_volume_db(0)+10)
