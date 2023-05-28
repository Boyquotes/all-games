extends KinematicBody2D

var MAX_HP = 4
var HP = 4
var DMG = 1
var died = false

var is_moving_left = true

var player = false

var gravity =  50 # check https://www.youtube.com/watch?v=jQKxOEbbirA for more detail
var velocity = Vector2(0, 0)

var speed = 32 # pixels per second

var origin_point: Vector2

onready var HEALTH_MODULE = $HealthModule

# TODO adicionar mecânica de stunar quando tomar dano do chicote, vai ficar stunado por 1 segundo e perder um coração, atacar enquanto ele estiver stunado o acorda imediatamente e o inimigo vira na direção do player atirando

func _ready():
	origin_point = global_position
	HEALTH_MODULE.setup_health_view($GridContainer, MAX_HP)

func _process(_delta):
	if player:
		$Sprite.play("Shoot")
		var rotats = 0
		if is_moving_left:
			rotats = 3.14159
		Global.ADD_BULLET("res://Scenes/Projectiles/EnemyProjectile.tscn", [$Position2D.global_position, 0, DMG, '', rotats, 350])
		$ShootDelay.start()
		set_process(false)
	else:
		$Sprite.play("Walk")
		move_character()
		detect_turn_around()
	if MAX_HP > 10:
		$GridContainer.columns = 10
	else:
		$GridContainer.columns = MAX_HP
	if len($GridContainer.get_children()) != HP and HP >= 0:
		if len($GridContainer.get_children()) < HP:
			var textur = TextureRect.new()
			textur.texture = preload("res://Images/Others/Heart.png")
			$GridContainer.call_deferred("add_child", textur)
		else:
			$GridContainer.visible = true
			for z in range(0, (MAX_HP-HP)):
				$GridContainer.get_child(len($GridContainer.get_children())-z-1).texture = load("res://Images/Others/EmptyHeart.png")
	if HP <= 0:
		queue_free()

func move_character():
	velocity.x = -speed if is_moving_left else speed
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)

func detect_turn_around():
	if (not $RayCast2D.is_colliding() and is_on_floor()) or (is_on_floor() and is_on_wall()):
		TurnArround()

func TurnArround():
	is_moving_left = !is_moving_left
	scale.x = -scale.x

func _on_Eyes_area_entered(area):
	area = area.get_parent()
	if area.is_in_group("PLAYER"):
		player = true

func _on_Eyes_area_exited(area):
	area = area.get_parent()
	if area.is_in_group("PLAYER"):
		player = false

func _on_ShootDelay_timeout():
	set_process(true)

func ressurect():
	if died:
		Global.spawn('enemy', origin_point, get_parent())
		queue_free()

func die():
	set_process(false)
	visible = false
	
	for z in get_children():
		z.queue_free()
	
	died = true

func take_dmg(dmg):
	HP = HEALTH_MODULE.take_dmg(dmg, $GridContainer, HP, MAX_HP)
	
	if HP == 0:
		die()
