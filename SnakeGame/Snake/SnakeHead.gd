extends Position2D

var Parts = []#SnakePart scene list

var ALIVE = true
var control = true

#Fight infos:
#	o boost de ação duplica o valor da ação se acertado
#	se errar o tipo da defesa toma o dano cheio
#	se acertar o tipo da defesa pode defender no máximo o valor da defesa certa (pode defender todo o dano)

#ações do personagem no combate:
#	atacar físico, atacar mágico, defender físico, defender mágico

var EXP = 0 #upar de nível é: LEVEL*10+5
var LEVEL = 0
var COINS = 0
var HEALTH = 8
var SHIELD = 0
var ARMOR = 0
var DMG_FISICO = 0
var DMG_MAGICO = 0

var LastDir = 0
#0->left, 1->top, 2->right, 3->bottom
var ActualDir = 0

func _ready():
	Global.set_process_bit(self, false)
	Earn('Exp', Global.PRE_GAME['initial_exp'])
	Earn('Coin', Global.PRE_GAME['initial_coins'])
	UpdateStats()
	set_process(true)

func UpdateStats():
	for z in ['Coin', 'Health', 'Shield', 'Armor', 'DmgFis', 'DmgMag']:
		Earn(z, 0)

func _process(_delta):
	if control:
		if Input.is_action_just_pressed("ui_down") and LastDir != 1:
			SetDir(3)
		if Input.is_action_just_pressed("ui_left") and LastDir != 2:
			SetDir(0)
		if Input.is_action_just_pressed("ui_up") and LastDir != 3:
			SetDir(1)
		if Input.is_action_just_pressed("ui_right") and LastDir != 0:
			SetDir(2)
	if Input.is_action_just_pressed("C"):
		for z in $Camera.get_children():
			z.visible = !z.visible
	if Input.is_action_just_pressed("ESC") and get_tree().paused == false:
		$Camera/Options.visible = !$Camera/Options.visible
		LoadOptions()
	#if Input.is_action_just_pressed("F1") and get_tree().paused == false:
	#	$Camera/Helper.visible = !$Camera/Helper.visible
	#	LoadHelper()

func LoadOptions():
	$Camera/Options/Op/Grid/CameraSmooth.pressed = $Camera.is_follow_smoothing_enabled()

func LoadHelper():
	pass

func AddPart():
	AddAction('Up', 'SnakeLen', 1)
	var node = preload("res://Snake/SnakePart.tscn").instance()
	if len(Parts) > 1:
		node.position = Parts[-1].position+(Parts[-2].position.direction_to(Parts[-1].position))*Global.JUMP_DISTANCE
	elif len(Parts) == 1:
		node.position = position+(position.direction_to(Parts[-1].position))*Global.JUMP_DISTANCE
	else:
		node.position = [Vector2(-1, 0), Vector2(0, -1), Vector2(1, 0), Vector2(0, 1)][[2, 3, 0, 1][LastDir]]*Global.JUMP_DISTANCE
	get_tree().get_root().call_deferred("add_child", node)
	Parts.append(node)

func RemovePart():
	AddAction('Down', 'SnakeLen', 1)
	var node = Parts[-1]
	Parts.remove(-1)
	node.queue_free()

func SetDir(dir: int):
	ActualDir = dir
	Walk()
	#$Timer.start()

func LevelUp():
	AddAction('Up', 'Level', 1)
	Earn('Health', 2)
	AddPart()
	get_tree().get_nodes_in_group("SNAKELEN_LABEL")[0].text = str(len(Parts))
	EXP -= LEVEL*10+5
	LEVEL += 1
	if EXP >= LEVEL*10+5:
		LevelUp()
	get_tree().get_nodes_in_group("LEVEL_LABEL")[0].text = str(LEVEL)
	control = false
	Global.Spawn('ChooseUpgrade', global_position)

func Earn(what, amount, part = false):
	if amount > 0:
		AddAction('Up', what, amount)
	elif amount < 0:
		AddAction('Down', what, amount)
	if what == 'Coin':
		COINS += amount
		get_tree().get_nodes_in_group("COINS_LABEL")[0].text = str(COINS)
	elif what == 'Health':
		HEALTH += amount
		get_tree().get_nodes_in_group("HEALTH_LABEL")[0].text = str(HEALTH)
	elif what == 'Shield':
		SHIELD += amount
		get_tree().get_nodes_in_group("SHIELD_LABEL")[0].text = str(SHIELD)
	elif what == 'Armor':
		ARMOR += amount
		get_tree().get_nodes_in_group("ARMOR_LABEL")[0].text = str(ARMOR)
	elif what == 'DmgFis':
		DMG_FISICO += amount
		get_tree().get_nodes_in_group("DMGFIS_LABEL")[0].text = str(DMG_FISICO)
	elif what == 'DmgMag':
		DMG_MAGICO += amount
		get_tree().get_nodes_in_group("DMGMAG_LABEL")[0].text = str(DMG_MAGICO)
	elif what == 'Exp':
		EXP += amount
		if EXP >= LEVEL*10+5:
			LevelUp()
		get_tree().get_nodes_in_group("EXP_LABEL")[0].text = str(EXP)
	elif what == 'SnakePart':
		for z in amount:
			RemovePart()
	if part:
		AddPart()
		get_tree().get_nodes_in_group("SNAKELEN_LABEL")[0].text = str(len(Parts))

func Boost():
	print('boost')

func VerifyCollision():
	for z in Parts:
		if global_position == z.global_position:
			ALIVE = false
			print('Died')
			break
	for z in get_tree().get_nodes_in_group("Collider"):
		if z.global_position == global_position:
			if z.type in [1, 2, 3, 4]:
				Global.SpawnRoom(z)
			elif z.type == 0:
				ALIVE = false
				print('Died')
			elif z.type == 5:
				z.Die()
				Earn('Coin', 1)
			elif z.type == 6:
				Global.StartFight(z)
			elif z.type == 7:
				Global.Spawn('SHOP', z.global_position)
			elif z.type == 8:
				Global.Spawn('ChooseGoldenAppleReward', global_position)
				z.Die()
			elif z.type == 9:
				if z.manager.ActualObjectives[0] == z:
					z.manager.ActualObjectives.remove(z.manager.ActualObjectives.find(z))
					if len(z.manager.ActualObjectives) > 0:
						for x in z.manager.ActualObjectives:
							x.AnalyseColor()
					else:
						Earn('Exp', z.manager.ObjectiveExpReward)
					
					z.Die()
			elif z.type == 10:
				z.Die()
				Earn('Exp', 1)
			break

func Walk():
	for z in range(len(Parts)-1, -1, -1):
		if z == 0:
			Parts[z].position = position
		else:
			Parts[z].position = Parts[z-1].position
	position += [Vector2(-1, 0), Vector2(0, -1), Vector2(1, 0), Vector2(0, 1)][ActualDir]*Global.JUMP_DISTANCE
	LastDir = ActualDir
	Global.Step()
	VerifyCollision()

func _on_Timer_timeout():
	Walk()
	$Timer.start()

var Actions = []

func AddAction(what: String, icon: String, amount):
	var node = preload("res://Snake/ActionsLog/Action.tscn").instance()
	$Camera/ActionsLog.call_deferred('add_child', node)
	node.Run(what, icon, amount)
	Actions.append(node)
	if len(Actions) > 15:
		Actions[0].queue_free()
		Actions.pop_front()

func _on_CameraSmooth_toggled(button_pressed):
	$Camera.set_enable_follow_smoothing(button_pressed)
