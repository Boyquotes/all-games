extends Node2D

const CLOCKS = ["res://Audios/Clock/Clock-1.wav", "res://Audios/Clock/Clock-2.wav", "res://Audios/Clock/Clock-3.wav", "res://Audios/Clock/Clock-4.wav", "res://Audios/Clock/Clock-5.wav"]

const TEXTURES = {
	#'name': 'texture',
	'cyclop': "res://Images/Bosses/Cyclop.png",
	'medusa': "res://Images/Bosses/Medusa.png",
	'killerWasp': "res://Images/Bosses/KillerWasp.png",
	
	'ogre': "res://Images/Enemies/Ogre.png",
	'bat': "res://Images/Enemies/Bat.png",
	'skeleton': "res://Images/Enemies/Skeleton.png",
	'spider': "res://Images/Enemies/Spider.png",
	'guard': "res://Images/Enemies/Guard.png",
	'slime': "res://Images/Enemies/Slime.png",
	'ghoul': "res://Images/Enemies/Ghoul.png",
	'witch': "res://Images/Enemies/Witch.png",
	'vampire': "res://Images/Enemies/Vampire.png",
	'magicArmor': "res://Images/Enemies/MagicArmor.png",
	'armoredSkeleton': "res://Images/Enemies/ArmoredSkeleton.png",
	'werewolf': "res://Images/Enemies/Werewolf.png",
}

const ENEMY = {
	#0 = deffend, 1 = attack, 2 = use magic
	#max_length = 4
	#'enemy_name': ['action sequence'],
	'bat': [1],
	'slime': [2],
	
	'skeleton': [0, 1],
	'spider': [1, 1],
	'ghoul': [2, 1],
	'witch': [0, 2],
	'vampire': [1, 2],
	'magicArmor': [2, 2],
	
	#'': [0, 0, 1],
	'armoredSkeleton': [0, 1, 1],
	'werewolf': [0, 2, 1],
	#'': [1, 0, 1],
	#'': [1, 1, 1],
	#'': [1, 2, 1],
	#'': [2, 0, 1],
	#'': [2, 1, 1],
	#'': [2, 2, 1],
	
	#'': [0, 0, 2],
	#'': [0, 1, 2],
	#'': [0, 2, 2],
	#'': [1, 0, 2],
	#'': [1, 1, 2],
	#'': [1, 2, 2],
	#'': [2, 0, 2],
	#'': [2, 1, 2],
	#'': [2, 2, 2],
	
	'ogre': [0, 1, 0, 1],
	'guard': [0, 0, 1, 1],
}

const BOSSES = {
	'cyclop':     [0, 1, 0, 2, 0, 1, 0, 2, 2, 0, 1],
	'medusa':     [1, 2, 0, 0, 2, 1, 0, 2, 1, 1, 2],
	'killerWasp': [0, 1, 1, 0, 0, 2, 2, 1, 0, 2, 1],
}

func AddBoss():
	var list = []
	for z in BOSSES:
		list.append(z)
	var boss = list[Global.RANDOM.randi_range(0, len(list)-1)]
	$Enemy.texture = load(TEXTURES[boss])
	for z in BOSSES[boss]:
		actualPath.append(z)

func AddEnemyPath() -> void:
	if totalLoops < maxLoops:
		var list = []
		for z in ENEMY:
			list.append(z)
		var enemy = list[Global.RANDOM.randi_range(0, len(list)-1)]
		$Enemy.texture = load(TEXTURES[enemy])
		for z in ENEMY[enemy]:
			actualPath.append(z)
		totalLoops += 1
	else:
		actualPath.append('end')

func AddWalkPath() -> void:
	if totalLoops < maxLoops:
		var possi = ['f', 'l', 'r']
		var intBuf = Global.RANDOM.randi_range(1, 3)
		var remBuf = ''
		var sequence = []
		for _z in range(0, intBuf):
			var path = possi[Global.RANDOM.randi_range(0, len(possi)-1)]
			sequence.append(path)
			if len(possi) != 3:
				possi.append(remBuf)
			if path == 'l' or path == 'r':
				possi.remove(possi.find(path))
				remBuf = path
		for z in sequence:
			actualPath.append(z)
		totalLoops += 1
	else:
		actualPath.append('end')

func ChangePath(add = false) -> void:
	if add == true:
		if actualPath[0] in ['f', 'l', 'r']:
			AddEnemyPath()
		else:
			AddWalkPath()
	actualPath.pop_front()
	if str(actualPath[0]) != 'end':
		if actualPath[0] in ['f', 'l', 'r']:
			var map = {
				'f': "res://Images/Movement/F.png",
				'l': "res://Images/Movement/L.png",
				'r': "res://Images/Movement/R.png",
			}
			$Enemy.texture = load(map[actualPath[0]])
		SetAudio(actualPath[0])
	else:
		actualPath.pop_front()
		for z in $Actions.get_children():
			z.disabled = true
		$Enemy.visible = false
		$Sucess.visible = true
		SetAudio('suspense')
		yield(get_tree().create_timer(4), "timeout")
		$Audio.stop()
		SetAudio('scream')
		actionToAudioFinished = 'boss'

func AnalysePath(action) -> void:
	if str(action) == str(actualPath[0]):
		$RemainingTime.value += 1
		if len(actualPath) == 1:
			ChangePath(true)
		else:
			ChangePath()
	else:
		SetAudio('missed')
		$RemainingTime.value -= 2
		actionToAudioFinished = 'missed'

func SetAudio(audio):
	var map = {
		'missed': "res://Audios/Missed.wav",
		'f': "res://Audios/Forward.wav",
		'l': "res://Audios/Left.wav",
		'r': "res://Audios/Right.wav",
		'0': "res://Audios/Deffend.wav",
		'1': "res://Audios/Hit.wav",
		'2': "res://Audios/Magic.wav",
		'suspense': "res://Audios/Suspense.wav",
		'scream': "res://Audios/Scream.wav",
		'failed': "res://Audios/Failed.wav",
	}
	var map2 = {
		'f': $"Actions/Up",
		'l': $"Actions/Left",
		'r': $"Actions/Right",
		'0': $"Actions/Deffend",
		'1': $"Actions/Attack",
		'2': $"Actions/Magic",
	}
	for z in map2:
		if str(audio) != z:
			map2[z].set_modulate(Color(1, 1, 1, 0.392157))
		else:
			map2[z].set_modulate(Color(1, 1, 1, 1))
	$Audio.stop()
	$Audio.set_stream(load(map[str(audio)]))
	$Audio.play()

var totalLoops = 0
const maxLoops = 20
var actualLevel = 0
var actualPath = [null]

func _ready():
	Global.set_process_bit(self, false)
	AddWalkPath()
	ChangePath()
	set_process(true)

func _process(_delta):
	if Input.is_action_just_pressed("R") and $Audio.is_playing() == false:
		$Audio.play()
	if Input.is_action_just_pressed("ESC"):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/Menu.tscn")

func _on_Deffend_button_up():
	AnalysePath(0)

func _on_Magic_button_up():
	AnalysePath(2)

func _on_Attack_button_up():
	AnalysePath(1)

func _on_Left_button_up():
	AnalysePath('l')

func _on_Up_button_up():
	AnalysePath('f')

func _on_Right_button_up():
	AnalysePath('r')

func _on_RemainingTime_value_changed(value):
	if value <= 0:
		get_tree().paused = true
		$Failed.visible = true
		$Audio.stop()
		SetAudio('failed')
		actionToAudioFinished = 'failed'

func _on_Clock_timeout():
	$RemainingTime.value -= 1
	$Clock.start()
	if $Audio.is_playing() == false:
		$Clock/Clock.set_stream(load(CLOCKS[Global.RANDOM.randi_range(0, len(CLOCKS)-1)]))
		$Clock/Clock.play()

var actionToAudioFinished = ''
func _on_Audio_finished():
	match actionToAudioFinished:
		'boss':
			AddBoss()
			SetAudio(actualPath[0])
			totalLoops = 0
			for z in $Actions.get_children():
				z.disabled = false
			$Enemy.visible = true
			$Sucess.visible = false
		'failed':
	# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Scenes/Menu.tscn")
			get_tree().paused = false
		'missed':
			SetAudio(actualPath[0])
	actionToAudioFinished = ''
