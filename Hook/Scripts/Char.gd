extends Node2D

var GRAVITY = 0.5
var speed = 1
const UP = Vector2(0, -1)
var tipo = 'char'
var CONTROLE = true

var hooking = false

var ground = true
var moving = false
var anim_states = {
	'0': [false, false, 'Slow_fall'],#falling
	'1': [false, true, 'Slow_fall'],#falling
	'2': [true, false, 'Idle'],#idle
	'3': [true, true, 'Running'],#running
}

func _physics_process(_delta):
	var motion = Vector2.ZERO
	
	if ground == false:
		$KinematicBody2D.global_position[1] += GRAVITY
	
	ground = $KinematicBody2D.is_on_floor() || $KinematicBody2D.is_on_wall()
	moving = Input.get_action_strength("ui_right") || Input.get_action_strength("ui_left")
	
	
	for z in anim_states:
		if anim_states[z][0] == ground && anim_states[z][1] == moving:
			$KinematicBody2D/AnimatedSprite.play(anim_states[z][2])
			break
	
	
	if Input.is_action_pressed("ui_left") and CONTROLE == true || Input.is_action_pressed("ui_right") and CONTROLE == true:
		if Input.is_action_pressed("ui_right") and CONTROLE == true:
			$KinematicBody2D/AnimatedSprite.flip_h = false
			$KinematicBody2D.global_position[0] += speed
		if Input.is_action_pressed("ui_left") and CONTROLE == true:
			$KinematicBody2D/AnimatedSprite.flip_h = true
			$KinematicBody2D.global_position[0] -= speed
	$KinematicBody2D.move_and_slide(motion, UP)
