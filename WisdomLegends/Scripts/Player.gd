extends KinematicBody2D

#História do jogo:
# Um maluco roubou um livro mto brabo e está usando para várias coisas do mal, incluindo 
# reviver mortos e criando um exército para dominar o mundo
# Daí num reino o rei escolheu o seu melhor cavaleiro/guerreiro para ir tentar matar esse maluco,
# mas o guerreiro não era forte/bom o suficiente então o rei mandou ele treinar o físico em 3 lugares 
# diferentes para vencer o NECROMANCER, mas a cada vez que ele passava por um lugar ele aprendia 
# uma coisa nova e 1 pessoa era adicionada ao seu grupo pq ela curtiu o guerreiro e queria se juntar
# para enfrentar o maluco NECROMANCER.

#Lugares que o guerreiro foi:
# FLORESTA: lá ele encontrou uma ARQUEIRA que ensinou ele a habilidade ativa de arremessar sua espada
# (mecânica de arremessar espada e ela fica lá até ser pega pelo personagem) e também ensinou a 
# habilidade passiva que é pegar coisas/objetos/armas no chão e usá-las ao invés da espada
# (a espada nunca será substituída e é necessário estar com ela para passar a cena/nível/fase),
# e ela se juntou com ele nessa aventura,
# e ela ataca com flechas (colisão por projétil ao invés de colisão por ataque físico), tem esquiva e 
# parring (o parring dela na real ela desvia do ataque de forma que fica invulnerável)

# MONTANHA COM GELO E NEVE: lá ele encontrou um YETI que ensinou ele a habilidade ativa brutalidade, 
# uma habilidade que permite causar mais dano e se mover mais rápido 
# e também ensinou a habilidade passiva da brutalidade, que
# ele agora pode carregar o ataque básico da espada pra sair mais forte,
# o YETI se também se juntou a ele na jornada, ele não pode fazer parring, mas pode esquivar e atacar
# com ataque físico, mas com uma área maior e também pode carregar o ataque para dar mais dano

# DESERTO DE AREIA (pq pode ser de neve tmb): lá ele encontrou um mago, que ensinou a ele a habilidade
# ativa de como parar/desacelerar o tempo por um curto período e a habilidade passiva de refletir
# magias, pq antes ele não conseguia fazer isso, ele se juntou com o guerreiro e tem ataque de projétil
# que é teleguiado, o mago não pode esquivar, mas pode fazer um parring com um escudo mágico


# Algo de estranho acontece depois que o guerreiro aprende todas essas coisas, ele se sente mais 
# poderoso, mais SÁBIO, ele percebe que antes ele pensava que estaria atrás de força ou destreza
# para derrotar o NECROMANCER, mas na verdade tudo o que ele precisava era de conhecimento, nada 
# mudou em seu físico ou aparência, mas agora ele se sentia mais confiante do que nunca para
# cumprir a sua missão.

# Depois que ele termina de ir nos lugares ele voltou ao rei, mas tudo lá já estava destruído e o
# NECROMANCER o esperava para um embate final.


enum STATES {
	WALK = 0,
	DASH = 1,
	PARRY = 2,
	ATTACK = 3,
	RECOVERY = 4,
	IMMORTAL = 5,
}

enum CHARACTERS {
	WARRIOR = 0,
	ARCHER = 1,
	YETI = 2,
	MAGE = 3,
}

var INFOS = {
	'actual_health': 10,
	'max_health': 10,
	'dmg': 1,
	'speed': 200,
}

var PODE_TROCAR_DE_PERSONAGEM = true

const INTERESTELLAR = true
var can_fire = true
var can_parry = true
var auto_fire = false
var last_pos = Vector2.ZERO

var pause = false
var can_dash = true
var actual_state = STATES.WALK

func ATTACK(type):
	match type:
		'basic_sword':
			can_fire = false
			actual_state = STATES.ATTACK
			$AnimationPlayer.play("Sword_Attack")
			yield(get_tree().create_timer(0.1), "timeout")
			$HOLDER/SWORD_ATK/Collision.disabled = false
			yield(get_tree().create_timer(0.3), "timeout")
			$HOLDER/SWORD_ATK/Collision.disabled = true
		'parry':
			can_parry = false
			actual_state = STATES.PARRY
			$AnimationPlayer.play("Parrying")
			for z in $"HOLDER/PARRY_AREA".list:
				z.queue_free()
			yield(get_tree().create_timer(0.05), "timeout")
			for z in $"HOLDER/PARRY_AREA".list:
				z.queue_free()
			yield(get_tree().create_timer(0.05), "timeout")
			for z in $"HOLDER/PARRY_AREA".list:
				z.queue_free()
			yield($AnimationPlayer, "animation_finished")

func _process(_delta):
	#if Input.is_action_just_pressed("ESC"):
	#	pause = true
	#if Input.is_action_just_pressed("E"):
	#	auto_fire = !auto_fire
	if actual_state != STATES.PARRY:
		$HOLDER.rotation = get_angle_to(get_global_mouse_position()) + deg2rad(90)
		if $HOLDER.rotation <= deg2rad(135) and $HOLDER.rotation > deg2rad(45):
			$Sprite.texture = load("res://Animations/Idle/PlayerRight.png")
		elif $HOLDER.rotation <= deg2rad(45) and $HOLDER.rotation > deg2rad(-45):
			$Sprite.texture = load("res://Animations/Idle/PlayerUp.png")
		elif $HOLDER.rotation <= deg2rad(225) and $HOLDER.rotation > deg2rad(135):
			$Sprite.texture = load("res://Animations/Idle/PlayerDown.png")
		else:
			$Sprite.texture = load("res://Animations/Idle/PlayerLeft.png")
	
	
		if can_dash and Input.is_action_just_pressed("SPACE"):
			actual_state = STATES.DASH
			INFOS['speed'] = 800
			can_dash = false
			$DASH.start()
			yield(get_tree().create_timer(0.18), "timeout")
			INFOS['speed'] = 0
			actual_state = STATES.RECOVERY
			#wait
			yield(get_tree().create_timer(0.1), "timeout")
			INFOS['speed'] = 200
	
	#$PauseArea.global_position = lerp(global_position, get_global_mouse_position(), 0.2)
		var input_dir: Vector2 = Vector2.ZERO
		input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input_dir = input_dir.normalized()
		if input_dir*INFOS['speed'] != Vector2.ZERO:
			actual_state = STATES.WALK
	# warning-ignore:return_value_discarded
			move_and_slide(input_dir*INFOS['speed'])
			#global_position += input_dir*Global.PLAYER_INFOS['speed']
		if Input.is_action_pressed("CLICK") and can_parry == true and can_fire == true or auto_fire == true and can_parry == true and can_fire == true:
			ATTACK('basic_sword')
			#Global.play_sound('shoot')
			#infos = [global_position, rotation_degrees, DMG, DIE, ROTATION, SPEED, TYPE]
			#var node = preload("res://Scenes/InterestellarProjectile.tscn").instance()
			#node.global_position = $Sprite/Gun/POINT.global_position
			#node.rotation_degrees = $Sprite/Gun.rotation_degrees
			#node.set_linear_velocity(Vector2(600, 0).rotated($Sprite/Gun.rotation))
			#get_tree().get_root().call_deferred("add_child", node)
			#can_fire = false
			#yield(get_tree().create_timer(Global.PLAYER_INFOS['shoot_delay']), "timeout")
			#can_fire = true
		if Input.is_action_just_pressed("RIGHT_CLICK") and can_parry == true and can_fire == true or auto_fire == true and can_parry == true and can_fire == true:
			ATTACK('parry')
	#$Sprite/Gun.look_at(get_global_mouse_position())

func _on_Area2D_area_entered(area):
	area = area.get_parent()
	if area.is_in_group("ENEMY_PROJECTILE"):
		Global.play_sound('hit')
		Global.ADD_DMG_LABEL(area.global_position, area.DMG, true)
		Global.INTERESTELAR_INFOS['actual_health'] -= area.DMG
		if area.DIE:
			area.find_node('Timer').stop()
			#area.BACK_TO_POOL()
			area.queue_free()

func _on_GoToMainMenu_button_up():
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Main_menu.tscn")

func _on_DASH_timeout():
	can_dash = true
	$DASH.stop()

func _on_SWORD_ATK_body_entered(body):
	#body = body.get_parent()
	if body.is_in_group("ENEMY"):
		body.INFOS['actual_health'] -= 1
		if body.actual_state != body.STATES.ATTACK:
			body.actual_state = body.STATES.KNOCKBACK
		body.POINT = global_position
		body.find_node('Recover').start()

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		'Parrying':
			actual_state = STATES.WALK
			can_parry = true
		'Sword_recovery':
			can_fire = true
		'Sword_Attack':
			$AnimationPlayer.play("Sword_recovery")

