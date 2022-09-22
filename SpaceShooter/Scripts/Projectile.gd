extends Node2D

onready var PLAYER = get_tree().get_nodes_in_group("PLAYER")[0]

var DIR = Vector2.ZERO
var SPEED = 10

var ORIGIN = 'UP'
var MODE = 'normal'

#CRIAR

# wide
# fullwide

#CRIAR

var FROG_JUMPS = 0#max = 20

func _ready() -> void:
	Global.set_process_bit(self, false)
	set_process(true)
	START()

func START() -> void:
	visible = true
	$HANDLER/Area2D/CollisionShape2D.disabled = false
	var splitos
	splitos = MODE.split('_or_')
	if len(splitos) != 1:
		var randu = Global.RANDOM.randi_range(0, len(splitos)-1)
		MODE = splitos[randu]
	
	var and_split
	and_split = MODE.split('_and_')
	if len(and_split) != 1:
		MODE = and_split[0]
		for z in range(1, len(and_split)):
			var node = load("res://Scenes/Projectile.tscn").instance()
			match ORIGIN:
				'UP':
					node.global_position = Vector2(Global.RANDOM.randi_range(0, 800), 0)
				'DOWN':
					node.global_position = Vector2(Global.RANDOM.randi_range(0, 800), 800)
				'LEFT':
					node.global_position = Vector2(0, Global.RANDOM.randi_range(0, 800))
				'RIGHT':
					node.global_position = Vector2(800, Global.RANDOM.randi_range(0, 800))
			node.ORIGIN = ORIGIN
			node.MODE = and_split[z]
			get_parent().call_deferred("add_child", node)
	
	match MODE:
		'normal':
			DIR = global_position.direction_to(PLAYER.global_position)
		'fast':
			DIR = global_position.direction_to(PLAYER.global_position)
			SPEED *= 1.5
			$HANDLER/ColorRect.color = Color(1, 0, 1)
		'lightspeed':
			DIR = global_position.direction_to(PLAYER.global_position)
			SPEED *= 2
			$HANDLER/ColorRect.color = Color(0, 0, 1)
		'sinuous':
			$HANDLER/ColorRect.color = Color(0.5, 0.5, 0)
			$AnimationPlayer.play("Sinuous")
		'random':
			$HANDLER/ColorRect.color = Color(0, 1, 0)
			DIR = global_position.direction_to(Vector2(Global.RANDOM.randi_range(0, 800), Global.RANDOM.randi_range(0, 800)))
		'frog':
			$HANDLER/ColorRect.color = Color(0, 1, 0.5)
			SPEED = 0
			$FROG_JUMPS.start()
		'fullwide':
			SPEED = 5
			match ORIGIN:
				'UP':
					global_position = Vector2(400, 0)
					set_scale(Vector2(25, 1))
					DIR = global_position.direction_to(Vector2(400, 800))
				'DOWN':
					global_position = Vector2(400, 800)
					set_scale(Vector2(25, 1))
					DIR = global_position.direction_to(Vector2(400, 0))
				'LEFT':
					global_position = Vector2(0, 400)
					set_scale(Vector2(1, 25))
					DIR = global_position.direction_to(Vector2(800, 400))
				'RIGHT':
					global_position = Vector2(800, 400)
					set_scale(Vector2(1, 25))
					DIR = global_position.direction_to(Vector2(0, 400))
		'wide':
			DIR = global_position.direction_to(PLAYER.global_position)
			if ORIGIN == 'UP' or ORIGIN == 'DOWN':
				set_scale(Vector2(4, 1))
			else:
				set_scale(Vector2(1, 4))
	if MODE in Global.ENEMIES_DISCOVERED:
		pass
	else:
		Global.ENEMIES_DISCOVERED.append(MODE)

func _process(_delta) -> void:
	global_position += (DIR*SPEED)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
	#get_parent().BULLET_POOL.append(self)
	#DIR = Vector2.ZERO
	#visible = false
	#$Area2D/CollisionShape2D.disabled = true
	#get_parent().call_deferred("remove_child", self)


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()


func _on_FROG_JUMPS_timeout():
	FROG_JUMPS += 1
	$Arrow.look_at(PLAYER.global_position)
	$Arrow.visible = true
	yield(get_tree().create_timer(0.1), "timeout")
	$Arrow.visible = false
	DIR = global_position.direction_to(PLAYER.global_position)
	SPEED = 20
	yield(get_tree().create_timer(0.08), "timeout")
	SPEED = 0
	$FROG_JUMPS.stop()
	if FROG_JUMPS < 21:
		$FROG_JUMPS.start()
	else:
		queue_free()
