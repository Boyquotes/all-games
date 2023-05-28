extends Node2D

var MAX_ENEMIES_IN_SCENE = 15

onready var ENERGY_PER_SECOND_VIEW = $Status/EnergyPerTick/ENERGY_PER_SECOND_VIEW
onready var FIREWALL_POINTS_VIEW = $Status/GridContainer2/GridContainer/FIREWALL_POINTS_VIEW
onready var POSITIONED_DEFENSES = $Status/PositionedDefenses/POSITIONED_DEFENSES

onready var costs = {
	Global.HABILITIES.SHIELD: $Habilities/SHIELD/GridContainer/Cost,
	Global.HABILITIES.WALL: $Habilities/WALL/GridContainer/Cost,
	Global.HABILITIES.PREVENTION: $Habilities/PREVENTION/GridContainer/Cost,
	Global.HABILITIES.WANDERING_FIREWALL: $Habilities/WANDERING/GridContainer/Cost,
	Global.HABILITIES.ENCRYPTED_PIPE: $Habilities/ENCRYPTED/GridContainer/Cost
}

onready var ENERGY_PROGRESS = $Status/ENERGY_PROGRESS
onready var ENEMIES_REMAINING_PROGRESS = $EnemiesRemainingProgress
onready var ENERGY_PER_TICK_PROGRESS = $Status/EnergyPerTick/ENERGY_PER_TICK_PROGRESS

onready var enemies_remaining = len(get_tree().get_nodes_in_group("ENEMY"))

var last_wave = 0
var ticks_remaining = 0 # wave_1 = 5
var enemies_per_tick = 0 # wave_1 = 1

var INFOS = {
	'base_info': 'Ponha o mouse acima de um botão para ver suas informações',
	
	'shield': Global.TUTORIAL['shield'][0],
	'wall': Global.TUTORIAL['wall'][0],
	'prevention': Global.TUTORIAL['prevention'][0],
	'wandering_firewall': Global.TUTORIAL['wandering_firewall'][0],
	'encrypted_pipe': Global.TUTORIAL['encrypted_pipe'][0],
	
	'up_shield': Global.TUTORIAL['up_shield'][0],
	'up_wall': Global.TUTORIAL['up_wall'][0],
	'up_prevention': Global.TUTORIAL['up_prevention'][0],
	'up_wandering_firewall': Global.TUTORIAL['up_wandering_firewall'][0],
	'up_encrypted_pipe': Global.TUTORIAL['up_encrypted_pipe'][0],
	
	'max_health': 'Legal, com isso posso aprimorar a resistência máxima do meu Firewall',
	'energy_per_tick': 'Boa, com isso posso aprimorar a quantidade de energia que ganho por segundo',
	'max_energy': 'Isso, com isso posso aprimorar a capacidade máxima de energia que posso ter',
	
	'actual_health': 'Legal, com isso posso recuperar a resistência do meu Firewall',
	
	'mega_shield': Global.TUTORIAL['mega_shield'][0],
	'mega_wall': Global.TUTORIAL['mega_wall'][0],
	'mega_prevention': Global.TUTORIAL['mega_prevention'][0],
	'mega_encrypted_pipe': Global.TUTORIAL['mega_encrypted_pipe'][0],
	'mega_wandering_firewall': Global.TUTORIAL['mega_wandering_firewall'][0],
	
	'hourglass_power_up': 'Com essa habilidade posso desacelerar a velocidade de tudo, tendo mais tempo para me preparar contra os invasores',
	'bomb_power_up': 'Com essa habilidade posso impedir todos os atuais invasores',
}

func set_info_text(text):
	$Status/DynamiContextIndicator/INFO.text = str(text)

func show_info(info):
	set_info_text(INFOS[info])

func reset_info():
	set_info_text(INFOS['base_info'])

func show_near_firewall_alert():
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("NearFirewallAlert")
		
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musics"), Global.musics.get_volume_db()/2)
		
		Global.play_sound('laugh')
		
		yield(get_tree().create_timer(4), "timeout")
		
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musics"), Global.musics.get_volume_db()*2)

func show_hability(hability):
	hability = Global.HABILITY_BY_NAME[hability]
	
	costs[hability].get_parent().get_parent().visible = true
	setup_habilities_cost()
	
	Global.show_tutorial(Global.NAME_BY_HABILITY[hability])

var started_increasing_max_enemies = false

func setup_wave():
	ticks_remaining = 0
	enemies_per_tick = 1
	
	var increment_buffer = floor(last_wave / 5)
	
	for _z in range(0, increment_buffer):
		ticks_remaining += 1
	
	enemies_per_tick += floor(last_wave / 10)
	
	var wave = last_wave + 1
	
	ticks_remaining += wave * 5
	
	last_wave = wave
	
	$WaveStatus/Label.text = str(last_wave)
	
	if Global.WAVE_TO_UNLOCK_ENEMY.get(last_wave, null) != null:
		if !(Global.WAVE_TO_UNLOCK_ENEMY[last_wave] in Global.PLAYER_INFOS['unlocked_enemies']):
			Global.PLAYER_INFOS['unlocked_enemies'].append(Global.WAVE_TO_UNLOCK_ENEMY[last_wave])
	
	if last_wave % 10 == 0:
		Global.MONEY_BUFFER += 1
	
	ENEMIES_REMAINING_PROGRESS.max_value = enemies_per_tick * ticks_remaining
	
	if last_wave == 6:
		show_conversation('PartialConversation1')
	
	if last_wave == 12:
		show_conversation('PartialConversation2')
	
	if last_wave == 18:
		show_conversation('FinalConversation')
	
	if last_wave >= 18 and started_increasing_max_enemies == false:
		$IncreaseMaxEnemies.start()
		started_increasing_max_enemies = true

const GAME_SOUNDS = ['game_1', 'game_2']

func do_music_loop():
	for z in GAME_SOUNDS:
		Global.play_sound(z)
		yield(Global.musics, "finished")

func _ready():
	setup_wave()
	yield(get_tree().create_timer(0.25), "timeout")
	setup_habilities_cost()
	
	Global.show_tutorial('firewall')
	
	do_music_loop()
	
	$IngameConfigurations/Configurations.in_game = true

func setup_habilities_cost():
	for z in costs:
		costs[z].text = str(Global.HABILITIES_COST[z])
	
	var visibles = 0
	
	for z in $Habilities.get_children():
		if z.visible == true:
			visibles += 1
	
	$Habilities.columns = visibles

func return_random_enemy_spawn_position():
	var possibilities = []
	
	for z in range(1, 45):
		possibilities.append(Vector2(272 + z*16, 80))
	
	return possibilities[Global.RANDOM.randi_range(0, len(possibilities)-1)]

func return_random_enemy():
	return Global.PLAYER_INFOS['unlocked_enemies'][Global.RANDOM.randi_range(0, len(Global.PLAYER_INFOS['unlocked_enemies'])-1)]

func _process(_delta):
	ENERGY_PROGRESS.max_value = Global.PLAYER_INFOS['max_energy']
	ENERGY_PROGRESS.value = Global.PLAYER_INFOS['energy']
	ENEMIES_REMAINING_PROGRESS.value = enemies_remaining
	ENERGY_PER_TICK_PROGRESS.max_value = Global.PLAYER_INFOS['max_energy']
	ENERGY_PER_TICK_PROGRESS.value = Global.PLAYER_INFOS['energy_per_tick']
	
	ENERGY_PER_SECOND_VIEW.text = str(Global.PLAYER_INFOS['energy_per_tick'])
	FIREWALL_POINTS_VIEW.text = str(Global.PLAYER_INFOS['firewall_points'])
	POSITIONED_DEFENSES.text = str(len(get_tree().get_nodes_in_group("BLOCK")))
	
	if Global.PLAYER_INFOS['actual_health'] == 0:
		if last_wave > 12:
			show_conversation('DyeConversationAfter12')
		elif last_wave <= 12 and last_wave > 6:
			show_conversation('DyeConversationBefore12')
		elif last_wave <= 6:
			show_conversation('DyeConversationBefore6')

func show_conversation(which):
		get_tree().paused = true
		var dialog = Dialogic.start(which)
		dialog.set_pause_mode(2)
		$Dialogs.add_child(dialog)
		yield(dialog, "dialogic_signal")
		get_tree().paused = false

func next_wave():
	setup_wave()

func _on_Tick_timeout():
	enemies_remaining = len(get_tree().get_nodes_in_group("ENEMY"))
	
	for z in get_tree().get_nodes_in_group("ENEMY"):
		z._on_tick()
	
	Global._on_tick()
	
	if ticks_remaining > 0:
		if len(get_tree().get_nodes_in_group("ENEMY")) < MAX_ENEMIES_IN_SCENE:
			for _z in range(0, enemies_per_tick):
				Global.spawn(return_random_enemy(), return_random_enemy_spawn_position(), self)
			
			ticks_remaining -= 1
	
	if ticks_remaining == 0 and enemies_remaining == 0:
		next_wave()
	
	for z in get_tree().get_nodes_in_group("PREVENTION"):
		z.shoot()
	
	for z in get_tree().get_nodes_in_group("WANDERING"):
		z.each_tick()

func _on_Pause_button_up():
	get_tree().paused = true
	$Paused.visible = true

func _on_Configurations_button_up():
	get_tree().paused = !get_tree().paused
	$IngameConfigurations/Configurations.is_in_game()
	$IngameConfigurations/Configurations.visible = true

func _on_Go_button_up():
	get_tree().paused = false
	$Paused.visible = false

func _on_IncreaseMaxEnemies_timeout():
	MAX_ENEMIES_IN_SCENE += 1
	$IncreaseMaxEnemies.start()

func _on_Dicionario_button_up():
	Global.play_sound('button_pressed')
	get_tree().paused = true
	$Dicionario.visible = true

func _on_VoltarDicionario_button_up():
	Global.play_sound('button_pressed')
	get_tree().paused = false
	$Dicionario.visible = false


func run_forced_tutorial(which):
	Global.play_sound('button_pressed')
	Global.show_forced_tutorial(which)

func _on_Shield_button_up():
	run_forced_tutorial('shield')

func _on_Wall_button_up():
	run_forced_tutorial('wall')

func _on_Prevention_button_up():
	run_forced_tutorial('prevention')

func _on_Wandering_button_up():
	run_forced_tutorial('wandering_firewall')

func _on_Encrypted_button_up():
	run_forced_tutorial('encrypted_pipe')

func _on_UpShield_button_up():
	run_forced_tutorial('up_shield')

func _on_UpWall_button_up():
	run_forced_tutorial('up_wall')

func _on_UpPrevention_button_up():
	run_forced_tutorial('up_prevention')

func _on_UpWandering_button_up():
	run_forced_tutorial('up_wandering_firewall')

func _on_UpEncrypted_button_up():
	run_forced_tutorial('up_encrypted_pipe')

func _on_Brutus_button_up():
	run_forced_tutorial('brutus')

func _on_Phishing_button_up():
	run_forced_tutorial('phishing')

func _on_Sql_button_up():
	run_forced_tutorial('sql')

func _on_Ransomware_button_up():
	run_forced_tutorial('ransomware')

func _on_Spoofing_button_up():
	run_forced_tutorial('spoofing')

func _on_MegaShield_button_up():
	run_forced_tutorial('mega_shield')

func _on_MegaWall_button_up():
	run_forced_tutorial('mega_wall')

func _on_MegaPrevention_button_up():
	run_forced_tutorial('mega_prevention')

func _on_MegaEncrypted_button_up():
	run_forced_tutorial('mega_encrypted_pipe')

func _on_MegaWandering_button_up():
	run_forced_tutorial('mega_wandering_firewall')

func _on_ComoJogar_button_up():
	run_forced_tutorial('como_jogar')

func _on_Firewall_button_up():
	run_forced_tutorial('firewall')
