extends KinematicBody2D

const MOVE_SPEED = 200			# Speed to walk with
const GRAVITY = 50				# Gravity applied every second
const MAX_SPEED = 800			# Maximum speed the player is allowed to move
const FRICTION_AIR = 0.95		# The friction while airborne
const FRICTION_GROUND = 0.85	# The friction while on the ground
const CHAIN_PULL = 75

var velocity = Vector2(0,0)		# The velocity of the player (kept over time)
var chain_velocity := Vector2(0,0)

var CONTROLE = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		match event.get_button_index():
			1:
				if event.pressed:
					# We clicked the mouse -> shoot()
					$Chain.shoot(event.position - get_viewport().size * 0.5)
				else:
					# We released the mouse -> release()
					$Chain.release()
			2:
				pass

var ground = true
var moving = false
var can_fire = true
var anim_states = {
	'0': [false, false, 'Slow_fall'],#falling
	'1': [false, true, 'Slow_fall'],#falling
	'2': [true, false, 'Idle'],#idle
	'3': [true, true, 'Running'],#running
}

# This function is called every physics frame
func _physics_process(_delta: float) -> void:
	$Pointer.look_at(get_global_mouse_position())
	ground = is_on_floor() || is_on_wall()
	moving = Input.get_action_strength("ui_right") || Input.get_action_strength("ui_left")
	
	for z in anim_states:
		if anim_states[z][0] == ground && anim_states[z][1] == moving:
			$AnimatedSprite.play(anim_states[z][2])
			break
	
	if Input.is_action_pressed("ui_left") and CONTROLE == true || Input.is_action_pressed("ui_right") and CONTROLE == true:
		if Input.is_action_pressed("ui_right") and CONTROLE == true:
			$AnimatedSprite.flip_h = false
		if Input.is_action_pressed("ui_left") and CONTROLE == true:
			$AnimatedSprite.flip_h = true
	
	# Walking
	var walk = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")) * MOVE_SPEED

	# Falling
	velocity.y += GRAVITY

	# Hook physics
	if $Chain.hooked and $Chain/Tip.global_position.distance_to(global_position) > 20:
		# `to_local($Chain.tip).normalized()` is the direction that the chain is pulling
		chain_velocity = to_local($Chain.tip).normalized() * CHAIN_PULL
		if chain_velocity.y > 0:
			# Pulling down isn't as strong
			chain_velocity.y *= 0.55
		else:
			# Pulling up is stronger
			chain_velocity.y *= 1.65
		if sign(chain_velocity.x) != sign(walk):
			# if we are trying to walk in a different
			# direction than the chain is pulling
			# reduce its pull
			chain_velocity.x *= 0.7
	else:
		# Not hooked -> no chain velocity
		chain_velocity = Vector2(0,0)
	velocity += chain_velocity

	velocity.x += walk		# apply the walking
# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2.UP)	# Actually apply all the forces
	velocity.x -= walk		# take away the walk speed again
	# ^ This is done so we don't build up walk speed over time

	# Manage friction and refresh jump and stuff
	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	var grounded = is_on_floor()
	if grounded:
		velocity.x *= FRICTION_GROUND	# Apply friction only on x (we are not moving on y anyway)
		if velocity.y >= 5:		# Keep the y-velocity small such that
			velocity.y = 5		# gravity doesn't make this number huge
	elif is_on_ceiling() and velocity.y <= -5:	# Same on ceilings
		velocity.y = -5

	# Apply air friction
	if !grounded:
		velocity.x *= FRICTION_AIR
		if velocity.y > 0:
			velocity.y *= FRICTION_AIR

func _on_Hit_body_entered(body):
	if body.is_in_group("ENEMY") and global_position[1] < body.global_position[1]:
		#little jump to player and kill the enemy
		body.queue_free()
