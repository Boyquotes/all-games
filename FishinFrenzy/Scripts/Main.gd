extends Node2D

var PullQuality = ''
var fishingLineHealth = 100
var region = ''

var CanPull = true

var fishInfos = {
	'nome': '',
	'peso': 0,
	'preço': 0,
	'genero': 0,
}

func _ready():
	add_user_signal("FISH_CAUGHT", ['fish'])
# warning-ignore:return_value_discarded
	connect("FISH_CAUGHT", self, "_on_FISH_CAUGHT")
	Global.set_process_bit(self, false)
	set_process(true)

func _on_FISH_CAUGHT(fish):
	get_tree().paused = true
	var weight = Global.ReturnFishWeight(fish)
	fishInfos['nome'] = fish
	fishInfos['peso'] = weight
	fishInfos['preço'] = Global.ReturnFishValue(fish, weight)
	fishInfos['genero'] = ["res://Image/Others/FemGender.png", "res://Image/Others/MascGender.png"][Global.RANDOM.randi_range(0, 1)]
	
	$AfterCatchFish/GridContainer/Fish/Img.texture = load(Fishes.FISHES[fish][0])
	for z in range(1, 6):
		if Fishes.FISHES[fish][2] > z:
			$AfterCatchFish/GridContainer/Fish/FishInfos/Level.get_child(z-1).texture = preload("res://Image/Others/FilledStar.png")
		else:
			$AfterCatchFish/GridContainer/Fish/FishInfos/Level.get_child(z-1).texture = preload("res://Image/Others/EmptyStar.png")
	
	$AfterCatchFish/GridContainer/Fish/FishInfos/Name/Gender.texture = load(fishInfos['genero'])
	$AfterCatchFish/GridContainer/Fish/FishInfos/Name/Name.text = fish
	
	$AfterCatchFish/GridContainer/Fish/FishInfos/Peso/Peso.text = str(fishInfos['peso'])
	
	$"AfterCatchFish/GridContainer/Fish/FishInfos/Preço/Preço".text = str(fishInfos['preço'])
	
	$AfterCatchFish.visible = true

func GenerateFish(fish) -> void:
	var node = preload("res://Scenes/Fish.tscn").instance()
	node.INFOS['fish'] = fish
	node.INFOS['fish_level'] = Fishes.FISHES[fish][2]
	call_deferred("add_child", node)

func GenerateStunPoint() -> void:
	var randiPos = Vector2(Global.RANDOM.randi_range(54, 528), Global.RANDOM.randi_range(64, 448))
	var node = preload("res://Scenes/StunPoint.tscn").instance()
	node.global_position = randiPos
	call_deferred("add_child", node)

func ReturnBuildedPoints(_indexExceptions: Array = []) -> Array:
	var bufARRAY = []
	bufARRAY.append($VaraLine.get_points()[0])
	bufARRAY.append(get_global_mouse_position())
	bufARRAY.append($Fish.global_position)
	
	#var b = $VaraLine.get_points()
	#bufARRAY = [b[0], get_global_mouse_position(), $Fish.global_position]
	#for z in range(0, len($VaraLine.get_points())):
	#	if z in indexExceptions:
	#		#lerp($VaraLine.get_points()[z], get_global_mouse_position(), 0.3)
	#		bufARRAY.append(get_global_mouse_position())
	#	elif z == len($VaraLine.get_points()):
	#		bufARRAY.append($Fish.global_position)
	#	else:
	#		bufARRAY.append($VaraLine.get_points()[z])
	return bufARRAY

var calculatedAngle

func _process(_delta):
	calculatedAngle = abs(rad2deg(Vector2(300, 520).angle_to_point(get_global_mouse_position()))+90-$Fish.INFOS['actual_pull_angle'])
	for _z in range(0, 1):
		if calculatedAngle < 10:
			PullQuality = 'Excellent'
			if $Fish.INFOS['rage'] == true:
				PullFish(0.225)
			else:
				PullFish(0.45)
			break
		if calculatedAngle < 25:
			PullQuality = 'Great'
			if $Fish.INFOS['rage'] == true:
				PullFish(0.1)
			else:
				PullFish(0.2)
			break
		if calculatedAngle < 45:
			PullQuality = 'Good'
			if $Fish.INFOS['rage'] == true:
				PullFish(0.05)
			else:
				PullFish(0.1)
			break
		if $Fish.INFOS['actual_state'] == $Fish.STATES.STUNNED:
			PullFish(0.15)
		else:
			PullQuality = 'Bad'
			#match PullQuality:
				#'Excellent':
				#	pass
				#'Great':
				#	pass
				#'Good':
				#	pass
				#'Bad':
				#	pass
			PullFish(-(0.4+$Fish.INFOS['fish_level']/2))
			fishingLineHealth -= 0.01*($Fish.INFOS['fish_level'])
			if $Fish.INFOS['rage'] == true:
				fishingLineHealth -= 0.05*($Fish.INFOS['fish_level'])
	$Utils/PullQuality.text = PullQuality
	
	$Utils/FishingLineHealth.value = fishingLineHealth
	
	$VaraLine.points = ReturnBuildedPoints()
	
	if Input.is_action_just_pressed("ACTION") and CanPull == true:
		CanPull = false
		$Utils/FishingLineHealth/Pull.value = 0
		if $Fish.INFOS['rage'] == false:
			match PullQuality:
				'Excellent':
					PullFish(ReturnFishPull(4))
					$Fish.addStun(Player.INFOS['Hook'][1]*2)
				'Great':
					PullFish(ReturnFishPull(3))
					$Fish.addStun(Player.INFOS['Hook'][1])
				'Good':
					PullFish(ReturnFishPull(2))
				'Bad':
					if $Fish.INFOS['already_stunned'] == true or $Fish.INFOS['actual_state'] == $Fish.STATES.STUNNED:
						PullFish(ReturnFishPull(1))
					else:
						PullFish(-($Fish.INFOS['fish_level']*2))
						fishingLineHealth -= $Fish.INFOS['fish_level']*1.5
		else:
			fishingLineHealth -= $Fish.INFOS['fish_level']*3
		#wait for CanPull
		for z in 100:
			$Utils/FishingLineHealth/Pull.value += 1
			yield(get_tree().create_timer(0.01), "timeout")
		CanPull = true
		#wait for CanPull
	$FishStun.value = $Fish.INFOS['stun_bar']

func ReturnFishPull(multiplier):
	var buf = 0
	if Player.INFOS['Rod'][2] == region:
		buf = Player.INFOS['Rod'][1]
	return (Player.INFOS['Hook'][1]+buf)*multiplier

func PullFish(amount:float):
	if amount > 0:
		amount = amount - (amount*($Fish.INFOS['fish_level']/20))
		var division = 10
		var part = (amount*10)/division
		for _z in range(0, division):
			$Fish.global_position[1] += part
			yield(get_tree().create_timer(0.1/division), "timeout")
			
		yield(get_tree().create_timer(0.1), "timeout")
		
		part = (amount*9)/division
		for _z in range(0, division):
			$Fish.global_position[1] -= part
			yield(get_tree().create_timer(0.1/division), "timeout")
	else:
		$Fish.global_position[1] += amount

func _on_GenerateStunPoint_timeout():
	GenerateStunPoint()
	$GenerateStunPoint.start()
