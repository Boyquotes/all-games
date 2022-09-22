extends Node2D

const LEVELS = [
		[
			['UP', 'normal', 0.2, 80],
			['DOWN', 'normal', 0.2, 60],
			['LEFT', 'normal', 0.2, 70],
			['RIGHT', 'normal', 0.2, 70],
		],
		[
			['UP', 'random', 0.1, 100],
			['RIGHT', 'random', 0.1, 100],
			['DOWN', 'random', 0.1, 100],
			['LEFT', 'random', 0.1, 100],
		],
		[
			['UP', 'sinuous', 0.3, 50],
			['UP', 'sinuous', 0.2, 50],
			['UP', 'sinuous', 0.1, 50],
			['UP', 'sinuous', 0.05, 50],
		],
		#
		[
			['UP', 'normal_or_random', 0.2, 100],
			['LEFT', 'normal_or_random', 0.2, 100],
			['DOWN', 'normal_or_random', 0.2, 110],
			['RIGHT', 'normal_or_random', 0.2, 130],
		],
		[
			['UP', 'sinuous_or_normal', 0.2, 100],
			['UP', 'sinuous_or_normal', 0.18, 110],
			['UP', 'sinuous_or_normal', 0.16, 130],
			['UP', 'sinuous_or_normal', 0.14, 170],
		],
		[
			['UP', 'sinuous_or_random', 0.2, 100],
			['UP', 'sinuous_or_random', 0.18, 100],
			['UP', 'sinuous_or_random', 0.16, 110],
			['UP', 'sinuous_or_random', 0.14, 130],
		],
		#
		[
			['LEFT', 'fast', 0.2, 70],
			['UP', 'fast', 0.2, 70],
			['DOWN', 'fast', 0.2, 70],
			['RIGHT', 'fast', 0.2, 70],
		],
		[
			['LEFT', 'fast_or_random', 0.1, 100],
			['RIGHT', 'fast_or_random', 0.1, 110],
			['DOWN', 'fast_or_random', 0.1, 130],
			['UP', 'fast_or_random', 0.1, 160],
		],
		#
		[
			['DOWN', 'lightspeed', 0.25, 60],
			['UP', 'lightspeed', 0.25, 60],
			['RIGHT', 'lightspeed', 0.25, 60],
			['LEFT', 'lightspeed', 0.25, 60],
		],
		[
			['DOWN', 'lightspeed_or_normal', 0.1, 100],
			['RIGHT', 'lightspeed_or_normal', 0.1, 110],
			['UP', 'lightspeed_or_normal', 0.1, 130],
			['LEFT', 'lightspeed_or_normal', 0.1, 160],
		],
		#
		[
			['UP', 'normal', 0.05, 150],
			['RIGHT', 'normal', 0.05, 150],
			['LEFT', 'normal', 0.05, 150],
			['DOWN', 'normal', 0.05, 150],
		],
		[
			['LEFT', 'normal_or_random', 0.01, 250],
			['UP', 'normal_or_sinuous', 0.01, 250],
			['RIGHT', 'normal_or_fast', 0.01, 250],
			['DOWN', 'normal_or_lightspeed', 0.01, 250],
		],
		#
		[
			['UP', 'frog', 0.4, 50],
			['DOWN', 'frog', 0.3, 65],
			['LEFT', 'frog', 0.2, 90],
			['RIGHT', 'frog', 0.1, 120],
		],
		[
			['DOWN', 'frog_and_normal', 0.2, 80],
			['RIGHT', 'frog_and_random', 0.2, 80],
			['UP', 'frog_and_sinuous', 0.2, 80],
			['LEFT', 'frog_and_fast', 0.2, 80],
		],
		#
		[
			['UP', 'wide', 0.2, 100],
			['DOWN', 'wide', 0.2, 100],
			['LEFT', 'wide', 0.2, 100],
			['RIGHT', 'wide', 0.2, 100],
		],
		
		[
			['LEFT', 'wide_and_normal', 0.2, 100],
			['DOWN', 'wide_and_random', 0.2, 100],
			['UP', 'wide_and_sinuous', 0.2, 100],
			['RIGHT', 'wide_and_fast', 0.2, 100],
		],
		#
		
		[
			['UP', 'fullwide', 0.8, 18],
			['DOWN', 'fullwide', 0.8, 18],
			['LEFT', 'fullwide', 0.8, 18],
			['RIGHT', 'fullwide', 0.8, 18],
		],
		
		[
			['LEFT', 'fullwide_and_normal', 0.8, 18],
			['DOWN', 'fullwide_and_random', 0.8, 18],
			['UP', 'fullwide_and_sinuous', 0.8, 18],
			['RIGHT', 'fullwide_and_fast', 0.8, 18],
		],
		
		
		
		#OBJECTIVES
		[
			['RIGHT', 'normal', 0.5, 2, '1_Square'],
			['DOWN', 'random', 0.4, 2, '1_Square'],
			['LEFT', 'fast', 0.5, 2, '1_Square'],
			['UP', 'sinuous', 0.4, 2, '1_Square'],
		],
		[
			['DOWN', 'normal', 0.5, 2, '1_Diamond'],
			['RIGHT', 'random', 0.4, 2, '1_Diamond'],
			['LEFT', 'fast', 0.5, 2, '1_Diamond'],
			['UP', 'sinuous', 0.4, 2, '1_Diamond'],
		],
		[
			['LEFT', 'normal', 0.5, 2, '1_Triangle'],
			['RIGHT', 'random', 0.4, 2, '1_Triangle'],
			['DOWN', 'fast', 0.5, 2, '1_Triangle'],
			['UP', 'sinuous', 0.4, 2, '1_Triangle'],
		],
		[
			['UP', 'normal', 0.5, 2, '1_Circle'],
			['DOWN', 'random', 0.4, 2, '1_Circle'],
			['RIGHT', 'frog', 0.5, 2, '1_Circle'],
			['LEFT', 'wide', 0.4, 2, '1_Circle'],
		],
		
		[
			['DOWN', 'normal', 0.4, 2, '1_Pentagon'],
			['LEFT', 'random', 0.4, 2, '1_Pentagon'],
			['RIGHT', 'frog', 0.4, 2, '1_Pentagon'],
			['UP', 'wide', 0.4, 2, '1_Pentagon'],
		],
		#OBJECTIVES
		
		#DOUBLE OBJECTIVES
		[
			['DOWN', 'normal', 0.3, 2, '2_Square'],
			['LEFT', 'random', 0.3, 2, '2_Triangle'],
			['UP', 'normal', 0.3, 2, '2_Circle'],
			['RIGHT', 'random', 0.3, 2, '2_Pentagon'],
		],
		#DOUBLE OBJECTIVES
		
		#DOT OBJECTIVES
		[
			['UP', 'normal', 0.3, 2, '8_Dot'],
			['RIGHT', 'random', 0.15, 2, '15_Dot'],
			['DOWN', 'wide', 0.3, 2, '22_Dot'],
			['LEFT', 'frog', 0.2, 2, '30_Dot'],
		],
		[
			['LEFT', 'fast', 0.28, 2, '10_Dot'],
			['DOWN', 'lightspeed', 0.28, 2, '10_Dot'],
			['RIGHT', 'fast', 0.2, 2, '12_Dot'],
			['UP', 'lightspeed', 0.2, 2, '12_Dot'],
		],
		#DOT OBJECTIVES
		
		#REALLY HARD OBJECTIVES
		[
			['UP', 'fullwide_and_normal', 1, 2, '1_Square'],
			['DOWN', 'fullwide_and_random', 1, 2, '1_Square'],
			['LEFT', 'fullwide_and_wide', 1, 2, '1_Diamond'],
			['RIGHT', 'fullwide_and_fast', 1, 2, '1_Diamond'],
		],
		[
			['UP', 'fullwide_and_normal', 1, 2, '1_Triangle'],
			['DOWN', 'fullwide_and_random', 1, 2, '1_Triangle'],
			['LEFT', 'fullwide_and_wide', 1, 2, '1_Circle'],
			['RIGHT', 'fullwide_and_fast', 1, 2, '1_Circle'],
		],
		[
			['UP', 'fullwide_and_normal', 1, 2, '1_Pentagon'],
			['DOWN', 'fullwide_and_random', 1, 2, '1_Pentagon'],
			['LEFT', 'fullwide_and_wide', 1, 2, '10_Dot'],
			['RIGHT', 'fullwide_and_fast', 1, 2, '15_Dot'],
		],
		#REALLY HARD OBJECTIVES
]

var SPAWNING = false
var POINTS_AREA_CONFIRMATIONS = []

func _ready():
	Global.MAX_LEVEL = len(LEVELS)
	Global.set_process_bit(self, false)
	set_process(true)
	add_user_signal("NO_ENEMIES")
	if Global.MUSIC_INDEX >= len(Global.ALL_MUSIC_LOOPS):
		Global.MUSIC_INDEX = 0
	$AudioStreamPlayer.set_stream(load(Global.ALL_MUSIC_LOOPS[Global.MUSIC_INDEX]))
	$AudioStreamPlayer.play()

func SPAWN(ORIGIN, MODE, DELAY, AMOUNT, POINTS_AREA=''):
	SPAWNING = true
	$AnimationPlayer.play("NextWave")
	yield($AnimationPlayer, "animation_finished")
	var splito = '0'
	if POINTS_AREA != '':
		splito = POINTS_AREA.split('_')
	for _z in range(0, int(splito[0])):
		var node = preload("res://Scenes/PointsArea.tscn").instance()
		node.TYPE = splito[1]
		node.global_position = Vector2(Global.RANDOM.randi_range(100, 700), Global.RANDOM.randi_range(100, 700))
		call_deferred("add_child", node)
	for z in AMOUNT:
		var node = preload("res://Scenes/Projectile.tscn").instance()
		match ORIGIN:
			'UP':
				node.global_position = Vector2(Global.RANDOM.randi_range(0, 800), 0)
			'DOWN':
				node.global_position = Vector2(Global.RANDOM.randi_range(0, 800), 800)
			'LEFT':
				node.global_position = Vector2(0, Global.RANDOM.randi_range(0, 800))
			'RIGHT':
				node.global_position = Vector2(800, Global.RANDOM.randi_range(0, 800))
		node.ORIGIN = ORIGIN
		node.MODE = MODE
		call_deferred("add_child", node)
		$delay.set_wait_time(DELAY)
		$delay.start()
		yield($delay, "timeout")
	while len(POINTS_AREA_CONFIRMATIONS) != int(splito[0]):
		var node = preload("res://Scenes/Projectile.tscn").instance()
		match ORIGIN:
			'UP':
				node.global_position = Vector2(Global.RANDOM.randi_range(0, 800), 0)
			'DOWN':
				node.global_position = Vector2(Global.RANDOM.randi_range(0, 800), 800)
			'LEFT':
				node.global_position = Vector2(0, Global.RANDOM.randi_range(0, 800))
			'RIGHT':
				node.global_position = Vector2(800, Global.RANDOM.randi_range(0, 800))
		node.ORIGIN = ORIGIN
		node.MODE = MODE
		call_deferred("add_child", node)
		$delay.set_wait_time(DELAY)
		$delay.start()
		yield($delay, "timeout")
	if len(POINTS_AREA_CONFIRMATIONS) != 0:
		for z in POINTS_AREA_CONFIRMATIONS:
			z.queue_free()
		for z in get_tree().get_nodes_in_group("PATH"):
			z.queue_free()
	POINTS_AREA_CONFIRMATIONS.clear()
	SPAWNING = false
	yield(self, "NO_ENEMIES")
	Global.actual_wave += 1

func _process(_delta):
	if Input.is_action_just_pressed("R"):
		POINTS_AREA_CONFIRMATIONS.clear()
	# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/Game.tscn")
		get_tree().paused = false
	if Input.is_action_just_pressed("ESC"):
		get_tree().paused = true
		$ESC.visible = true
		$ESC/GridContainer/MusicSelector/Handler/ActualMusic.text = str(Global.MUSIC_INDEX+1)
		$ESC/GridContainer/LEVELS.text = 'Levels Completed: '+str(Global.actual_level+1)+'/'+str(Global.MAX_LEVEL)
	if Input.is_action_just_pressed("Q"):
		get_tree().paused = false
	# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
	if len(get_tree().get_nodes_in_group("ENEMY_PROJECTILE")) == 0:
		emit_signal("NO_ENEMIES")
	if len(get_tree().get_nodes_in_group("ENEMY_PROJECTILE")) == 0 and SPAWNING == false:
		if len(LEVELS) > Global.actual_level:
			if len(LEVELS[Global.actual_level]) > Global.actual_wave:
				var points = ''
				if len(LEVELS[Global.actual_level][Global.actual_wave])==5:
					points = LEVELS[Global.actual_level][Global.actual_wave][4]
				SPAWN(LEVELS[Global.actual_level][Global.actual_wave][0], LEVELS[Global.actual_level][Global.actual_wave][1], LEVELS[Global.actual_level][Global.actual_wave][2], LEVELS[Global.actual_level][Global.actual_wave][3], points)
				if len(LEVELS[Global.actual_level]) <= Global.actual_wave:
					Global.actual_wave = 0
					Global.HIGHEST_WAVE = 0
					Global.actual_level += 1
			else:
				if len(LEVELS) >= Global.actual_level + 1:
					Global.actual_level += 1
					Global.actual_wave = 0
					Global.MUSIC_INDEX += 1
			if Global.actual_level > Global.HIGHEST_LEVEL:
				Global.HIGHEST_LEVEL = Global.actual_level
				Global.HIGHEST_WAVE = 0
				Global.actual_wave = 0
			if Global.actual_wave > Global.HIGHEST_WAVE:
				Global.HIGHEST_WAVE = Global.actual_wave
	else:
		#ACTIVATE THE END
		pass
	#if Input.is_action_just_pressed("ui_down"):
		#SPAWN('UP', 'normal', 0.2, 100)

func _on_AudioStreamPlayer_finished():
	if Global.MUSIC_INDEX >= len(Global.ALL_MUSIC_LOOPS):
		Global.MUSIC_INDEX = 0
	$AudioStreamPlayer.set_stream(load(Global.ALL_MUSIC_LOOPS[Global.MUSIC_INDEX]))
	$AudioStreamPlayer.play()

func _on_RESUME_button_up():
	$ESC.visible = false
	get_tree().paused = false

func _on_MUSIC_value_changed(value):
	value *= 2
	if value != -10:
		AudioServer.set_bus_mute(1, false)
		AudioServer.set_bus_volume_db(1, value)
	else:
		AudioServer.set_bus_mute(1, true)
	Global.CONFIGURATIONS['music_volume'] = value
	$ESC/GridContainer/GridContainer/GridContainer/Label.text = str((value+10)/2)

func _on_QUIT_button_up():
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _on_PreviousMusic_button_up() -> void:
	if Global.MUSIC_INDEX != 0:
		Global.MUSIC_INDEX -= 1
	if Global.MUSIC_INDEX >= len(Global.ALL_MUSIC_LOOPS):
		Global.MUSIC_INDEX = 0
	$AudioStreamPlayer.set_stream(load(Global.ALL_MUSIC_LOOPS[Global.MUSIC_INDEX]))
	$AudioStreamPlayer.play()
	$ESC/GridContainer/MusicSelector/Handler/ActualMusic.text = str(Global.MUSIC_INDEX+1)

func _on_NextMusic_button_up() -> void:
	if Global.MUSIC_INDEX != len(Global.ALL_MUSIC_LOOPS)-1:
		Global.MUSIC_INDEX += 1
	if Global.MUSIC_INDEX >= len(Global.ALL_MUSIC_LOOPS):
		Global.MUSIC_INDEX = 0
	$AudioStreamPlayer.set_stream(load(Global.ALL_MUSIC_LOOPS[Global.MUSIC_INDEX]))
	$AudioStreamPlayer.play()
	$ESC/GridContainer/MusicSelector/Handler/ActualMusic.text = str(Global.MUSIC_INDEX+1)
