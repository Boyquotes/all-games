extends Node2D

onready var links = $Links		# A slightly easier reference to the links
var direction := Vector2(0,0)	# The direction in which the chain was shot
var tip := Vector2(0,0)			# The global position the tip should be in
								# We use an extra var for this, because the chain is 
								# connected to the player and thus all .position
								# properties would get messed with when the player
								# moves.

const SPEED = 100	# The speed with which the chain moves

var flying = false	# Whether the chain is moving through the air
var hooked = false	# Whether the chain has connected to a wall

const max_hook_distance = 350

# shoot() shoots the chain in a given direction
func shoot(dir: Vector2) -> void:
	$Tip/CollisionShape2D.disabled = false
	$Tip/Hook.set_texture(preload("res://assets/hook.png"))
	direction = dir.normalized()	# Normalize the direction and save it
	flying = true					# Keep track of our current scan
	tip = self.global_position		# reset the tip position to the player's position

# release() the chain
func release() -> void:
	flying = false	# Not flying anymore	
	hooked = false	# Not attached anymore
	$Tip/CollisionShape2D.disabled = true
	$Tip.global_position = get_parent().global_position

# Every graphics frame we update the visuals
func _process(_delta: float) -> void:
	self.visible = flying or hooked	# Only visible if flying or attached to something
	if not self.visible:
		return	# Not visible -> nothing to draw
	var tip_loc = to_local(tip)	# Easier to work in local coordinates
	# We rotate the links (= chain) and the tip to fit on the line between self.position (= origin = player.position) and the tip
	links.rotation = self.position.angle_to_point(tip_loc) - deg2rad(90)
	$Tip.rotation = self.position.angle_to_point(tip_loc) - deg2rad(90)
	links.position = tip_loc						# The links are moved to start at the tip
	links.region_rect.size.y = tip_loc.length()		# and get extended for the distance between (0,0) and the tip

# Every physics frame we update the tip position
func _physics_process(_delta: float) -> void:
	$Tip.global_position = tip	# The player might have moved and thus updated the position of the tip -> reset it
	if flying:
		if global_position.distance_to($Tip.global_position) > max_hook_distance:
			release()
		# `if move_and_collide()` always moves, but returns true if we did collide
		if $Tip.move_and_collide(direction * SPEED):
			if $Tip.move_and_collide(direction * SPEED).collider.is_in_group("HOOK"):
				$Tip.global_position = $Tip.move_and_collide(direction * SPEED).collider.find_node("Position2D").global_position
				$Tip/Hook.set_texture(preload("res://assets/hook_fixed.png"))
				hooked = true	# Got something!
				flying = false	# Not flying anymore
			elif $Tip.move_and_collide(direction * SPEED).collider.is_in_group("ENEMY"):
				for z in get_tree().get_nodes_in_group("ENEMY"):
					if z==$Tip.move_and_collide(direction * SPEED).collider:
						z.take_dmg(1)
						if z.is_moving_left == true and get_parent().global_position[0] > z.global_position[0]:
							z.TurnArround()
						if z.is_moving_left == false and get_parent().global_position[0] < z.global_position[0]:
							z.TurnArround()
				release()
			else:
				release()
	tip = $Tip.global_position	# set `tip` as starting position for next frame
