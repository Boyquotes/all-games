extends CharacterBody3D
class_name MovementController

const ORIGINAL_SPEED = 8

@export var gravity_multiplier := 3.0
@export var speed := 8
@export var acceleration := 8
@export var deceleration := 32
@export_range(0.0, 1.0, 0.05) var air_control := 0.3
@export var jump_height := 10
var direction := Vector3()
var input_axis := Vector2()
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
@onready var gravity: float = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* gravity_multiplier)

@onready var HEAD = $Head

enum STATES {
	MOVING, CHARGING_PUNCH, PUNCHING, SLAM
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

func slam():
	speed *= 3
	
	state = STATES.SLAM
	
	pointToSlam = HEAD.SLAM_POINT.get_collision_point()
	
	velocity.y = jump_height
	
	TRIGGERS['reset_slam'] = true
	
	slamDirection = global_position.direction_to(pointToSlam)

func getExtraPunchTime():
	return 0.25 * punchCharge

func punch():
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
	velocity.y = jump_height * 2
	
	speed /= 2
	
	TRIGGERS['reset_speed'] = true

# Called every physics tick. 'delta' is constant
func _physics_process(delta: float) -> void:
	if state == STATES.PUNCHING:
		input_axis = Vector2(1, 0)
	else:
		input_axis = Input.get_vector(&"move_back", &"move_forward", &"move_left", &"move_right")
	
	direction_input()
	
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
		if Input.is_action_just_pressed(&"super_jump"):
			doSuperJump()
		
		HEAD.CROSSHAIR.set_modulate(Color(1, 1, 1))
	else:
		if HEAD.canSlam:
			HEAD.CROSSHAIR.set_modulate(Color(0, 1, 1))
		else:
			HEAD.CROSSHAIR.set_modulate(Color(1, 1, 1))
		
		if Input.is_action_just_pressed(&"slam") and HEAD.canSlam and state == STATES.MOVING:
			slam()
		velocity.y -= gravity * delta
	
	if state == STATES.MOVING or state == STATES.CHARGING_PUNCH:
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
