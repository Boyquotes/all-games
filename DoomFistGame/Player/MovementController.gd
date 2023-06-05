extends CharacterBody3D
class_name MovementController

const ORIGINAL_SPEED = 8

@export var gravity_multiplier := 3.0
@export var speed: float = 8.0
@export var acceleration := 8
@export var deceleration := 32
@export_range(0.0, 1.0, 0.05) var air_control := 0.3
@export var jump_height: float = 10.0
var direction := Vector3()
var input_axis := Vector2()
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
@onready var gravity: float = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* gravity_multiplier)

@onready var HEAD = $Head

enum STATES {
	MOVING, CHARGING_PUNCH, PUNCHING, SLAM, SUPER_JUMPING
}

var state = STATES.MOVING

const MAX_PUNCH_CHARGE = 1
const SPEED_WHILE_PUNCH = 32
var punchCharge = 0
var punchChargeGain = 0.15
var pointToSlam = Vector3.ZERO
var slamDirection = Vector3.ZERO

var TRIGGERS = {
	'reset_speed': false,
	'reset_slam': false
}

var CAN = {# [can?, waitTime, cooldown_node_reference]
	'super_jump': [false, 6],
	'punch': [false, 5],
	'slam': [false, 4]
}

# TODO make combo system
var combo = 0
var comboHits = 0

var canAttack = true

func attack(which):
	incrementHit()
	canAttack = false
	
	if which == 'light':
		var currentAnim = $AnimationPlayer.get_current_animation()
		
		if currentAnim == 'recover_light_1':
			$AnimationPlayer.play('light_2')
		elif currentAnim == 'recover_light_2' or currentAnim == 'idle' or currentAnim == 'walk':
			$AnimationPlayer.play('light_1')

func _ready():
	for z in CAN:
		CAN[z].append(HEAD.addCooldownView(CAN[z][1], z, self))

func startCooldown(which):
	CAN[which][0] = false
	CAN[which][2].runCooldown()

func getExtraSlamJumpHeight(aimingPoint):
	var buffer = 0
	
	if aimingPoint.y > global_position.y:
		buffer = 0.5 * abs(abs(global_position.y) - abs(aimingPoint.y))
	
	return (jump_height/4) * buffer

func slam():
	startCooldown('slam')
	
	speed *= 3
	
	state = STATES.SLAM
	
	pointToSlam = HEAD.SLAM_POINT.global_position
	
	velocity.y = jump_height + getExtraSlamJumpHeight(pointToSlam)
	
	TRIGGERS['reset_slam'] = true
	
	slamDirection = global_position.direction_to(pointToSlam)

func getExtraPunchTime():
	return 0.25 * punchCharge

func punch():
	startCooldown('punch')
	
	HEAD.mouse_sensitivity /= 4
	
	speed = SPEED_WHILE_PUNCH
	acceleration = SPEED_WHILE_PUNCH
	
	state = STATES.PUNCHING
	
	await get_tree().create_timer(0.25 + getExtraPunchTime()).timeout
	
	state = STATES.MOVING
	
	speed = ORIGINAL_SPEED
	acceleration = ORIGINAL_SPEED
	HEAD.mouse_sensitivity *= 4

func addPunchCharge(amount):
	speed = 6
	
	state = STATES.CHARGING_PUNCH
	
	punchCharge += amount
	
	if punchCharge > MAX_PUNCH_CHARGE:
		punchCharge = MAX_PUNCH_CHARGE
	
	HEAD.setPunchChargeValue(punchCharge)

func doSuperJump():
	startCooldown('super_jump')
	
	velocity.y = jump_height * 2
	
	speed /= 1.5
	
	TRIGGERS['reset_speed'] = true
	
	state = STATES.SUPER_JUMPING
	
	await get_tree().create_timer(0.5).timeout
	
	state = STATES.MOVING

func getAttackInput():
	if Input.is_action_just_pressed("attack"):
		if canAttack and state == STATES.MOVING and Input.is_action_just_pressed("attack"):
			attack('light')

func _physics_process(delta: float) -> void:
	if state == STATES.PUNCHING:
		input_axis = Vector2(1, 0)
	else:
		input_axis = Input.get_vector(&"move_back", &"move_forward", &"move_left", &"move_right")
	
	direction_input()
	
	getAttackInput()
	
	if is_on_floor():
		if pointToSlam != Vector3.ZERO and TRIGGERS['reset_slam'] == true:
			state = STATES.MOVING
			TRIGGERS['reset_slam'] = false
			speed = ORIGINAL_SPEED
		
		if speed != ORIGINAL_SPEED and TRIGGERS['reset_speed']:
			speed = ORIGINAL_SPEED
			TRIGGERS['reset_speed'] = false
		
		if Input.is_action_just_pressed(&"jump"):
			velocity.y = jump_height
		
		if Input.is_action_just_pressed(&"super_jump") and state == STATES.MOVING and CAN['super_jump'][0]:
			doSuperJump()
		
		HEAD.CROSSHAIR.set_modulate(Color(1, 1, 1))
	else:
		if CAN['slam'][0]:
			HEAD.CROSSHAIR.set_modulate(Color(0, 1, 1))
		else:
			HEAD.CROSSHAIR.set_modulate(Color(1, 1, 1))
		
		if Input.is_action_just_pressed(&"slam") and state == STATES.MOVING and CAN['slam'][0]:
			slam()
		velocity.y -= gravity * delta
	
	if (state != STATES.PUNCHING and state != STATES.SLAM) and CAN['punch'][0]:
		if Input.is_action_pressed(&"charge_punch"):
			addPunchCharge(punchChargeGain * delta * 6)
		
		if Input.is_action_just_released(&"charge_punch"):
			punch()
			
			punchCharge = 0
			HEAD.setPunchChargeValue(punchCharge)
	
	accelerate(delta)
	
	move_and_slide()


func direction_input() -> void:
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	direction = aim.z * -input_axis.x + aim.x * input_axis.y
	
	if state == STATES.SLAM:
		direction = slamDirection


func accelerate(delta: float) -> void:
	# Using only the horizontal velocity, interpolate towards the input.
	var temp_vel := velocity
	temp_vel.y = 0
	
	var temp_accel: float
	var target: Vector3 = direction * speed
	
	if direction.dot(temp_vel) > 0:
		temp_accel = acceleration
	else:
		temp_accel = deceleration
	
	if not is_on_floor():
		temp_accel *= air_control
	
	temp_vel = temp_vel.lerp(target, temp_accel * delta)
	
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z
	
	match state:
		STATES.MOVING:
			if is_on_floor() and !($AnimationPlayer.get_current_animation() in ['light_1', 'light_2', 'recover_light_1', 'recover_light_2']):
				if velocity.is_zero_approx():
					$AnimationPlayer.play('idle')
				else:
					$AnimationPlayer.play('walk')
		STATES.CHARGING_PUNCH:
			$AnimationPlayer.play('charging_punch')
		STATES.PUNCHING:
			$AnimationPlayer.play('punching')
		STATES.SUPER_JUMPING:
			$AnimationPlayer.play('super_jump')
		STATES.SLAM:
			$AnimationPlayer.play('slam')

func incrementHit():
	comboHits += 1

func incrementCombo():
	combo += 1

func resetCombo():
	comboHits = combo
	
	var lastCombo = combo
	
	await get_tree().create_timer(2).timeout
	
	if combo == lastCombo: 
		comboHits = 0
		combo = 0

func analyseCombo():
	canAttack = combo >= comboHits

func _on_animation_player_animation_finished(anim_name):
	if anim_name != 'light_1' and anim_name != 'light_2':
		canAttack = true
	if anim_name == 'recover_light_1' or anim_name == 'recover_light_2':
		resetCombo()
	
	if anim_name == 'light_1' or anim_name == 'light_2':
		$AnimationPlayer.play('recover_' + anim_name)
		analyseCombo()


func _on_animation_player_animation_started(anim_name):
	if anim_name != 'light_1' and anim_name != 'light_2' and anim_name != 'recover_light_1'  and anim_name != 'recover_light_2':
		canAttack = true
