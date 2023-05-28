extends Node2D

onready var DOORS = [null, $RIGHT, $LEFT, $BOTTOM, $TOP]

const DIRS = [null, Vector2(-8, 0), Vector2(8, 0), Vector2(0, -8), Vector2(0, 8)]
var node: int
var point: Vector2

var negPossibilities = []

func _ready():
	Global.set_process_bit(self, false)
	if point:
		while DOORS[node].global_position != point:
			global_position += DIRS[node]
		if len(get_tree().get_nodes_in_group("ROOM")) > 3:
			Global.ACTUAL_ROOMS_LIST[0].Die()
		for z in get_children():
			z.VerifyDuplicated()
		BuildObstacle()
		BuildObjective()
		var nod
		for _z in range(0, Global.RANDOM.randi_range(1, Global.UPGRADES['max_coins_per_room'])):
			nod = Global.Spawn('Coin', ReturnInsideRandomValidPosition())
			exceps.append(nod)
			nod.manager = self
		for _z in range(0, Global.RANDOM.randi_range(1, Global.UPGRADES['max_enemies_per_room'])):
			nod = Global.Spawn('Enemy', ReturnInsideRandomValidPosition())
			exceps.append(nod)
			nod.manager = self
		for _z in range(0, Global.RANDOM.randi_range(1, Global.UPGRADES['max_exp_per_room'])):
			nod = Global.Spawn('Exp', ReturnInsideRandomValidPosition())
			exceps.append(nod)
			nod.manager = self
		for _z in range(0, Global.RANDOM.randi_range(1, Global.UPGRADES['max_traps_per_room'])):
			nod = Global.Spawn('Trap', ReturnInsideRandomValidPosition())
			exceps.append(nod)
			nod.manager = self
		Global.SHOP_BUFFER += 1
		if Global.SHOP_BUFFER == 10:
			Global.SHOP_BUFFER = 0
			nod = Global.Spawn('Shop', ReturnInsideRandomValidPosition())
			exceps.append(nod)
			nod.manager = self
		if Global.RANDOM.randi_range(1, 100) == 100:
			nod = Global.Spawn('GoldenApple', ReturnInsideRandomValidPosition())
			exceps.append(nod)
			nod.manager = self
	Global.ACTUAL_ROOMS_LIST.append(self)
	Global.ROOMS_SPAWNED += 1

const ALL_OBJECTIVES = ['FollowTrail', 'ActivatePoints']

var ActualObjectives = []
onready var ObjectiveExpReward = Global.RANDOM.randi_range(10, Global.RANDOM.randi_range(0, floor(Global.SNAKE.LEVEL*0.25))+20)

func BuildObjective():
	var buf = []
	for z in ALL_OBJECTIVES:
		if Global.LAST_OBJECTIVE != z:
			buf.append(z)
	Global.LAST_OBJECTIVE = buf[Global.RANDOM.randi_range(0, len(buf)-1)]
	match Global.LAST_OBJECTIVE:
		'FollowTrail':#sequência de pontos que o jogador tem que passar por cima para receber a recompensa (a ativação de um desbloqueia a possibilidade de ativação do próximo até que chega o último e a recompensa é colocada dentro do mapa)
			var lastPos: Vector2 = ReturnInsideRandomValidPosition()
			for _z in range(0, Global.RANDOM.randi_range(8, 15)):
				var p = ReturnNearValidPoint(lastPos)
				if p != Vector2(-1, -1):
					var nod = Global.Spawn('Objective', p)
					lastPos = p
					exceps.append(nod)
					nod.manager = self
					ActualObjectives.append(nod)
				else:
					break
		'ActivatePoints':#parecido com o follow trail, mas os pontos não são sequenciais, são aleatoriamente distantes um do próximo
			for _z in range(0, Global.RANDOM.randi_range(5, 10)):
				var nod = Global.Spawn('Objective', ReturnInsideRandomValidPosition())
				nod.manager = self
				exceps.append(nod)
				ActualObjectives.append(nod)

const OBSTACLE_PATTERNS = ['Plus', 'SmallRoom', 'Randoms', 'X', 'Slash', 'BackSlash', 'MediumRoom']

func BuildObstacle(force = '', buf = [0, 0]):
	var obstacle = OBSTACLE_PATTERNS[Global.RANDOM.randi_range(0, len(OBSTACLE_PATTERNS)-1)]
	if force != '':
		obstacle = force
	match obstacle:
		'Randoms':
			for z in 15:
				var nod = Global.Spawn('Wall', ReturnInsideRandomValidPosition())
				nod.manager = self
				exceps.append(nod)
		'Plus':
			var points = ReturnValidPoints()
			var central = Global.Spawn('Wall', points[480])
			central.manager = self
			exceps.append(central)
			negPossibilities.append(points[480])
			for z in [Vector2(-16, 0), Vector2(16, 0), Vector2(0, -16), Vector2(0, 16)]:
				for x in range(1, 8):
					var ponto = points[480]+(z*x)
					var nodez = Global.Spawn('Wall', ponto)
					nodez.manager = self
					exceps.append(nodez)
					negPossibilities.append(ponto)
		'X':
			var points = ReturnValidPoints()
			var central = Global.Spawn('Wall', points[480])
			central.manager = self
			exceps.append(central)
			negPossibilities.append(points[480])
			for z in [Vector2(-16, 16), Vector2(16, -16), Vector2(-16, -16), Vector2(16, 16)]:
				for x in range(1, 9):
					var ponto = points[480]+(z*x)
					var nodez = Global.Spawn('Wall', ponto)
					nodez.manager = self
					exceps.append(nodez)
					negPossibilities.append(ponto)
			for z in [Vector2(-16, 0), Vector2(16, 0), Vector2(0, -16), Vector2(0, 16)]:
				var ponto = points[480]+z
				var nodez = Global.Spawn('Wall', ponto)
				nodez.manager = self
				exceps.append(nodez)
				negPossibilities.append(ponto)
		'Slash':
			var points = ReturnValidPoints()
			var central = Global.Spawn('Wall', points[480])
			central.manager = self
			exceps.append(central)
			negPossibilities.append(points[480])
			for z in [Vector2(16, -16), Vector2(-16, 16)]:
				for x in range(1, 9):
					var ponto = points[480]+(z*x)
					var nodez = Global.Spawn('Wall', ponto)
					nodez.manager = self
					exceps.append(nodez)
					negPossibilities.append(ponto)
		'BackSlash':
			var points = ReturnValidPoints()
			var central = Global.Spawn('Wall', points[480])
			central.manager = self
			exceps.append(central)
			negPossibilities.append(points[480])
			for z in [Vector2(-16, -16), Vector2(16, 16)]:
				for x in range(1, 9):
					var ponto = points[480]+(z*x)
					var nodez = Global.Spawn('Wall', ponto)
					nodez.manager = self
					exceps.append(nodez)
					negPossibilities.append(ponto)
		'SmallRoom':
			var pointx = ReturnValidPoints()[480]
			var centerDistance = 4+buf[0]
			var actualPoint
			
			var mapDir1 = [Vector2(-16, -16), Vector2(16, 16), Vector2(16, -16), Vector2(-16, 16)]
			var mapDir2 = [[Vector2(16, 0), Vector2(0, 16)], [Vector2(0, -16), Vector2(-16, 0)], [Vector2(-16, 0), Vector2(0, 16)], [Vector2(0, -16), Vector2(16, 0)]]
			for z in [0, 1, 2, 3]:
				actualPoint = pointx + mapDir1[z]*centerDistance
				
				var nodez = Global.Spawn('Wall', actualPoint)
				nodez.manager = self
				exceps.append(nodez)
				negPossibilities.append(actualPoint)
				
				var dir1 = mapDir2[z][0]
				var dir2 = mapDir2[z][1]
				for k in [dir1, dir2]:
					for x in range(1, centerDistance-buf[1]):
						var ponto = actualPoint+(k*x)
						var nodezz = Global.Spawn('Wall', ponto)
						nodezz.manager = self
						exceps.append(nodezz)
						negPossibilities.append(ponto)
		'MediumRoom':
			BuildObstacle('SmallRoom', [3, 1])

var excepPos: Vector2
var exceps = []

func Die():
	for z in exceps:
		z.queue_free()
	var nod = Global.Spawn('Wall', excepPos)
	Global.ACTUAL_ROOMS_LIST[1].exceps.append(nod)
	nod.manager = Global.ACTUAL_ROOMS_LIST[1]
	Global.ACTUAL_ROOMS_LIST.pop_front()
	queue_free()

func ReturnValidPoints():
	var possibilities = []
	for z in range(0, 31):
		for x in range(0, 31):
			possibilities.append(Vector2($LEFT.global_position.x+z*16+16, $TOP.global_position.y+x*16+16))
	for z in negPossibilities:
		if z in possibilities:
			possibilities.remove(possibilities.find(z))
	return possibilities

func ReturnNearValidPoint(last: Vector2):
	var possibilities = ReturnValidPoints()
	var valids = []
	for z in [Vector2(-16, 0), Vector2(16, 0), Vector2(0, 16), Vector2(0, -16)]:
		if last + z in possibilities:
			valids.append(possibilities[possibilities.find(last+z)])
	if len(valids) > 0:
		var choosen = valids[Global.RANDOM.randi_range(0, len(valids)-1)]
		negPossibilities.append(choosen)
		return choosen
	else:
		return Vector2(-1, -1)

func ReturnInsideRandomValidPosition():
	var possibilities = ReturnValidPoints()
	var choosen = possibilities[Global.RANDOM.randi_range(0, len(possibilities)-1)]
	negPossibilities.append(choosen)
	return choosen

func Substituir(exception):
	excepPos = exception.global_position
	for z in DOORS:
		if z != null && z != exception:
			var pos = z.global_position
			z.queue_free()
			var nod = Global.Spawn('Wall', pos)
			exceps.append(nod)
			nod.manager = self










