extends Node2D

enum STATES{
	NORMAL = 0,
	STUNNED = 1,
	MOVING = 2
}

var INFOS = {
	'actual_state': STATES.NORMAL,
	'actual_pull_angle': 0.0,#max-left->-80.0; max-right->80.0 (ANGLE IN DEGREES)
	'actual_behavior': '',
	'behavior_list': ['behavior'],
	
	'show_inverse': false,
	
	'stun_bar': 0,#0-100
	'already_stunned': false,
	'rage': false,
	
	'fish_level': 1,#1-5 -> indica a dificuldade de pescar o peixe, e a complexidade de seus movimentos
	#fish_level é indicado por estrelas, exemplo: 5 estrelas dificuldade máxima
	
	'fish': 'fish_name',
}

func addStun(amount) -> void:
	INFOS['stun_bar'] += amount
	if INFOS['stun_bar'] >= 100:
		Stun(Player.INFOS['Hook'][1], true)
		INFOS['stun_bar'] = 0

func Stun(time, force = false) -> void:
	if INFOS['already_stunned'] == false or force == true:
		INFOS['already_stunned'] = true
		INFOS['actual_state'] = STATES.STUNNED
		yield(get_tree().create_timer(time), "timeout")
		INFOS['actual_state'] = STATES.NORMAL

func Wait(time):
	while INFOS['actual_state'] == STATES.STUNNED:
		yield(get_tree().create_timer(0.1), "timeout")
	var buf = 0
	match time:
		'short':
			buf = 1
		'long':
			buf = 2
		'no':
			buf = 0.5
	$WAIT.set_wait_time(buf)
	$WAIT.start()

func RunBehavior(behaviorPriority: String = '') -> void:
	while INFOS['actual_state'] == STATES.STUNNED:
		yield(get_tree().create_timer(0.1), "timeout")
	var waits = ''
	var beha = INFOS['behavior_list'][Global.RANDOM.randi_range(0, len(INFOS['behavior_list'])-1)]
	if behaviorPriority != '':
		beha = behaviorPriority
	match beha:
		
		'left_right_stay_short_time':
			SpecialBehaviorBuilder('Left-Right')
			waits = 'short'
		'left_right_stay_long_time':
			SpecialBehaviorBuilder('Left-Right')
			waits = 'long'
		'left_right_no_stay':
			SpecialBehaviorBuilder('Left-Right')
			waits = 'no'
		##
		
		'instant_change_stay_short_time':
			ChangePullDirection(Global.RANDOM.randi_range(-80, 80), 'instant')
			waits = 'short'
		'instant_change_stay_long_time':
			ChangePullDirection(Global.RANDOM.randi_range(-80, 80), 'instant')
			waits = 'long'
		'instant_change_no_stay':
			ChangePullDirection(Global.RANDOM.randi_range(-80, 80), 'instant')
			waits = 'no'
		##
		
		'long_distances_instant_changes_stay_short_time':
			BehaviorBuilder('long', 'instant')
			waits = 'short'
		'long_distances_instant_changes_stay_long_time':
			BehaviorBuilder('long', 'instant')
			waits = 'long'
		'long_distances_instant_changes_no_stay':
			BehaviorBuilder('long', 'instant')
			waits = 'no'
		##
		
		'long_distances_random_changes_stay_short_time':
			BehaviorBuilder('long', 'random')
			waits = 'short'
		'long_distances_random_changes_stay_long_time':
			BehaviorBuilder('long', 'random')
			waits = 'long'
		'long_distances_random_changes_no_stay':
			BehaviorBuilder('long', 'random')
			waits = 'no'
		##
		
		'short_distances_instant_changes_stay_short_time':
			BehaviorBuilder('short', 'instant')
			waits = 'short'
		'short_distances_instant_changes_stay_long_time':
			BehaviorBuilder('short', 'instant')
			waits = 'long'
		'short_distances_instant_changes_no_stay':
			BehaviorBuilder('short', 'instant')
			waits = 'no'
		##
		
		'short_distances_random_changes_stay_short_time':
			BehaviorBuilder('short', 'random')
			waits = 'short'
		'short_distances_random_changes_stay_long_time':
			BehaviorBuilder('short', 'random')
			waits = 'long'
		'short_distances_random_changes_no_stay':
			BehaviorBuilder('short', 'random')
			waits = 'no'
	yield(self, "MOVED")
	Wait(waits)
	yield($WAIT, "timeout")
	RunBehavior()

func ReturnDistance(dist):
	match dist:
		'long':
			if Global.RANDOM.randi_range(0, 1) == 0:
				if INFOS['actual_pull_angle'] + 60 <= 80:
					return INFOS['actual_pull_angle'] + 60
				else:
					return INFOS['actual_pull_angle'] - 60
			else:
				if INFOS['actual_pull_angle'] - 60 >= -80:
					return INFOS['actual_pull_angle'] - 60
				else:
					return INFOS['actual_pull_angle'] + 60
		'short':
			if Global.RANDOM.randi_range(0, 1) == 0:
				if INFOS['actual_pull_angle'] + 60 <= 80:
					return INFOS['actual_pull_angle'] + 30
				else:
					return INFOS['actual_pull_angle'] - 30
			else:
				if INFOS['actual_pull_angle'] - 60 >= -80:
					return INFOS['actual_pull_angle'] - 30
				else:
					return INFOS['actual_pull_angle'] + 30
		'random':
			return Global.RANDOM.randi_range(-80, 80)

func BehaviorBuilder(distance: String, changeSpeed: String) -> void:
	ChangePullDirection(ReturnDistance(distance), changeSpeed)

func SpecialBehaviorBuilder(type: String) -> void:
	match type:
		'Left-Right':
			var left = Global.RANDOM.randi_range(-80, -1)
			var right = Global.RANDOM.randi_range(1, 80)
			
			var buf = Global.RANDOM.randi_range(2, 4)
			for z in range(0, buf):
				if z % 2 == 0:
					ChangePullDirection(right, 'random')
				else:
					ChangePullDirection(left, 'random')
				yield(self, "MOVED")

func ChangePullDirection(angle: float, speed: String = '') -> void:
	if INFOS['actual_state'] == STATES.NORMAL:
		INFOS['actual_state'] = STATES.MOVING
		if speed == 'instant':
			speed = 'lightspeed'
		else:
			if speed == 'random' or speed == '':
				speed = ['slow','normal','fast','superfast'][Global.RANDOM.randi_range(0, 3)]
		var SPEEDS = {
			'slow': 0.5,
			'normal': 1,
			'fast': 2,
			'superfast': 3,
			'insane': 4,
			'lightspeed': 15,
		}
		var part = ceil(SPEEDS[speed]/(6-INFOS['fish_level']))
		if part == 0:
			part = 1
		var buffer = int((angle - INFOS['actual_pull_angle'])/part)
		if buffer < 0:
			part *= -1
			buffer = abs(buffer)
		
		if INFOS['fish_level'] >= 4 and Global.RANDOM.randi_range(0, 100) > 90:
			INFOS['show_inverse'] = true
			setModulate()
		for _z in range(0, buffer):
			if INFOS['actual_state'] == STATES.STUNNED:
				break
			else:
				INFOS['actual_pull_angle'] += part
				yield(get_tree().create_timer(0.01), "timeout")
		if INFOS['show_inverse'] == true:
			INFOS['show_inverse'] = false
			setModulate()
		while INFOS['actual_state'] == STATES.STUNNED:
			yield(get_tree().create_timer(0.1), "timeout")
		emit_signal("MOVED")
		INFOS['actual_state'] = STATES.NORMAL

# Deve existir vários tipos de comportamentos para o peixe
# e cada peixe deve ter 1 ou mais possibilidades de comportamento

func _ready():
	Global.set_process_bit(self, false)
	set_process(true)
	add_user_signal("MOVED", [])
	INFOS['behavior_list'] = Fishes.POSSIBLES_BEHAVIORS
	RunBehavior()

var last_pos = Vector2.ZERO

func _process(_delta):
	if INFOS['show_inverse'] == false:
		$Arrow.rotation_degrees = INFOS['actual_pull_angle']
	else:
		$Arrow.rotation_degrees = INFOS['actual_pull_angle']+180
	if last_pos.distance_to(global_position) > 32:
		var node = preload("res://Scenes/WaveEffect.tscn").instance()
		node.direction = last_pos.direction_to(global_position)
		node.global_position = global_position + last_pos.direction_to(global_position)*4
		node.Level = 4
		get_parent().call_deferred("add_child", node)
		last_pos = global_position
	global_position[0] = lerp(global_position[0], 3.75*INFOS['actual_pull_angle']+300, 0.85)
	if global_position[1] >= 520:
		get_parent().emit_signal("FISH_CAUGHT", INFOS['fish'])
	if global_position[1] <= 10:
		get_tree().paused = true

func setModulate() -> void:
	for _z in range(0, 1):
		if INFOS['rage'] == true:
			set_modulate(Color(1, 0, 0))
			break
		if INFOS['show_inverse'] == true:
			set_modulate(Color(0, 1, 0))
			break
		set_modulate(Color(1, 1, 1))
		break

func _on_WAIT_timeout():
	$WAIT.stop()

func _on_RAGE_timeout():
	while INFOS['actual_state'] == STATES.STUNNED:
		yield(get_tree().create_timer(0.1), "timeout")
	INFOS['rage'] = true
	setModulate()
	$RAGE.start()
	yield(get_tree().create_timer(INFOS['fish_level']*4+ceil(sqrt(INFOS['fish_level']*2))), "timeout")
	INFOS['rage'] = false
	setModulate()
