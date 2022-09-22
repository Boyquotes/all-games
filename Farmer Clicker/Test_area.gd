

# visão quase vertical

# CRIAR: 
#terreno para comprar - com plaquinha de preço
#terreno pronto para arar
#terreno arado seco
#terreno arado úmido

#plantas - criar cada planta de forma independente ao terreno



#sistemas de estação para aumentar os ganhos com cada plantio (avisar com mensagem fora do game que estação que está, para chamar o player pro jogo)

#MOVIMENTAÇÃO BÁSICA DE PERSONAGEM:
extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()

func get_input():
	look_at(get_global_mouse_position())
	velocity = Vector2()
	if Input.is_action_pressed("down"):
		velocity = Vector2(-speed, 0).rotated(rotation)
	if Input.is_action_pressed("up"):
		velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)

#CLICK AND MOVE
#extends KinematicBody2D

#export (int) var speed = 200

#var target = Vector2()
#var velocity = Vector2()

#func _input(event):
 #   if event.is_action_pressed("click"):
#        target = get_global_mouse_position()

#func _physics_process(delta):
 #   velocity = position.direction_to(target) * speed
#    # look_at(target)
#    if position.distance_to(target) > 5:
#        velocity = move_and_slide(velocity)
