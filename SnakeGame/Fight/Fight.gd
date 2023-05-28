extends Node2D

var ENEMY = {
	'atk_mag': 0,
	'atk_fis': 0,
	'armor': 0,
	'shield': 0,
	'health': 1,
	'coins': false,
	'exp': 3,
}

var correct = ''#example -> 'atk_mag'
const POSSIBILITIES = ['atk_mag', 'atk_fis', 'shield', 'armor']
onready var SNAKE = get_tree().get_nodes_in_group("SnakeHead")[0]

var deffenseBuf = 0
var lastAction = 'atk_fis'

var collider

var enteredHealth

func ReturnRandom(exception: String = ''):
	var ret
	if exception == '':
		ret = POSSIBILITIES[Global.RANDOM.randi_range(0, 3)]
	else:
		if deffenseBuf > 4:
			deffenseBuf = 0
			ret = ['atk_mag', 'atk_fis'][Global.RANDOM.randi_range(0, 1)]
		else:
			var buf = []
			for z in POSSIBILITIES:
				if z != exception:
					buf.append(z)
			ret = buf[Global.RANDOM.randi_range(0, 2)]
	if ret in ['shield', 'armor']:
		deffenseBuf += 1
	var map = {
		'atk_mag': "res://Textures/Icons/Atk_Mag.png",
		'atk_fis': "res://Textures/Icons/Atk_Fis.png",
		'shield': "res://Textures/Icons/Shield.png",
		'armor': "res://Textures/Icons/Armor.png"
	}
	$ColorRect/ColorRect2/EnemyInfos/GridContainer/NextAction.texture = load(map[ret])
	return ret

func End(win: bool):
	if win:
		if ENEMY['coins']:
			SNAKE.Earn('Coin', Global.RANDOM.randi_range(1, floor(SNAKE.LEVEL+Global.ROOMS_SPAWNED*0.2)+1))
		SNAKE.Earn('Exp', ENEMY['exp'])
		SNAKE.control = true
	else:
		print('Failed at Fighting!')
	SNAKE.UpdateStats()
	if enteredHealth < SNAKE.HEALTH:
		SNAKE.AddAction("Up", 'Health', abs(enteredHealth - SNAKE.HEALTH))
	elif enteredHealth > SNAKE.HEALTH:
		SNAKE.AddAction("Down", 'Health', abs(enteredHealth - SNAKE.HEALTH))
	collider.Die()
	queue_free()

func ReturnDamage(damage, defense):
	if damage < defense:
		return 1
	else:
		return floor(damage-defense)+1

func Fight(type: String):
	var map = {
		'atk_fis': SNAKE.DMG_FISICO,
		'atk_mag': SNAKE.DMG_MAGICO,
		'shield': ENEMY['atk_mag'],
		'armor': ENEMY['atk_fis'],
	}
	var value = map[type]
	var multiplier = 0.5
	if type != correct:
		if type in ['armor', 'shield']:
			value += 1
		if type in ['atk_fis', 'atk_mag']:
			value -= 1
	match correct:
		'atk_fis':
			ENEMY['health'] -= ReturnDamage(value, (ENEMY['armor']*multiplier))
		'atk_mag':
			ENEMY['health'] -= ReturnDamage(value, (ENEMY['shield']*multiplier))
		'armor':
			SNAKE.HEALTH -= ReturnDamage(value, (SNAKE.ARMOR*(1.5-multiplier)))
		'shield':
			SNAKE.HEALTH -= ReturnDamage(value, (SNAKE.SHIELD*(1.5-multiplier)))
	$ColorRect/ColorRect2/EnemyInfos/Health.value = ENEMY['health']
	$ColorRect/ColorRect2/PlayerInfos/Health.value = SNAKE.HEALTH
	SNAKE.UpdateStats()
	lastAction = type
	if SNAKE.HEALTH <= 0:
		SNAKE.HEALTH = 0
		End(false)
		return
	if ENEMY['health'] <= 0:
		ENEMY['health'] = 0
		End(true)
		return
	var anim_map = {
		'atk_fis': ['FIS-ARMOR', "res://Textures/Icons/Atk_Fis.png", "res://Textures/Icons/Armor.png"],
		'atk_mag': ['MAG-SHIELD', "res://Textures/Icons/Atk_Mag.png", "res://Textures/Icons/Shield.png"],
		'shield': ['DEF-SHIELD', "res://Textures/Icons/Shield.png", "res://Textures/Icons/Atk_Mag.png"],
		'armor': ['DEF-ARMOR', "res://Textures/Icons/Armor.png", "res://Textures/Icons/Atk_Fis.png"],
	}
	$ColorRect/ColorRect2/PlayerAction.texture = load(anim_map[correct][1])
	$ColorRect/ColorRect2/EnemyAction.texture = load(anim_map[correct][2])
	$ColorRect/ColorRect2/AnimatedSprite.play(anim_map[correct][0])
	UpdateEnemyStats()
	correct = ReturnRandom(correct)
	Lock(false)

func _ready():
	enteredHealth = SNAKE.HEALTH
	$ColorRect/ColorRect2/EnemyInfos/Health.max_value = ENEMY['health']
	$ColorRect/ColorRect2/PlayerInfos/Health.max_value = SNAKE.HEALTH
	Global.set_process_bit(self, false)
	UpdateEnemyStats()
	set_process(true)
	correct = ReturnRandom()
	Lock(false)

func UpdateEnemyStats():
	var lev = floor(ENEMY['health']*0.1+ENEMY['shield']*0.25+ENEMY['armor']*0.25+ENEMY['atk_fis']*0.2+ENEMY['atk_mag']*0.2)
	if lev <= 0:
		lev = 1
	$ColorRect/ColorRect2/EnemyStats/LEVEL.text = str(lev)
	$ColorRect/ColorRect2/EnemyStats/HEALTH.text = str(ENEMY['health'])
	$ColorRect/ColorRect2/EnemyStats/SHIELD.text = str(ENEMY['shield'])
	$ColorRect/ColorRect2/EnemyStats/ARMOR.text = str(ENEMY['armor'])
	$ColorRect/ColorRect2/EnemyStats/DMGFIS.text = str(ENEMY['atk_fis'])
	$ColorRect/ColorRect2/EnemyStats/DMGMAG.text = str(ENEMY['atk_mag'])

func _process(_delta):
	$ColorRect/ColorRect2/EnemyInfos/GridContainer/TextureProgress.value = $Timer.get_wait_time()-($Timer.get_wait_time()-$Timer.get_time_left())

func Lock(bol):
	for z in [$ColorRect/ColorRect2/PlayerInfos/Actions/a1, $ColorRect/ColorRect2/PlayerInfos/Actions/a2, $ColorRect/ColorRect2/PlayerInfos/Actions/a3, $ColorRect/ColorRect2/PlayerInfos/Actions/a4]:
		z.disabled = bol
	if bol == false:
		$ColorRect/ColorRect2/EnemyInfos/GridContainer/TextureProgress.max_value = $Timer.get_wait_time()
		$ColorRect/ColorRect2/EnemyInfos/GridContainer/TextureProgress.value = $Timer.get_wait_time()
		$Timer.start()
	else:
		$Timer.stop()
		Fight(lastAction)

func _on_a1_button_up():
	lastAction = 'atk_fis'
	Lock(true)

func _on_a2_button_up():
	lastAction = 'atk_mag'
	Lock(true)

func _on_a3_button_up():
	lastAction = 'armor'
	Lock(true)

func _on_a4_button_up():
	lastAction = 'shield'
	Lock(true)

func _on_Timer_timeout():
	Lock(true)
