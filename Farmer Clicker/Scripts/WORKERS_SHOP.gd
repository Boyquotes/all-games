extends Node2D

func _ready():
	REFRESH()

func _process(_delta):
	if Global.INVENTORY['diamonds'] == 0:
		$SHOP/GridContainer2/GridContainer2/REFRESH_WITH_DIAMONDS.disabled = true
	else:
		$SHOP/GridContainer2/GridContainer2/REFRESH_WITH_DIAMONDS.disabled = false
	if Global.INVENTORY['money'] < Global.INVENTORY['refresh_worker']:
		$SHOP/GridContainer2/GridContainer/REFRESH_WITH_GOLD.disabled = true
	else:
		$SHOP/GridContainer2/GridContainer/REFRESH_WITH_GOLD.disabled = false

func _on_REFRESH_WITH_GOLD_button_up():
	Global.INVENTORY['money'] -= Global.INVENTORY['refresh_worker']
	Global.INVENTORY['refresh_worker'] += 1
	REFRESH()

func _on_REFRESH_WITH_DIAMONDS_button_up():
	Global.INVENTORY['diamonds'] -= 1
	REFRESH()

func REFRESH():
	for z in $SHOP/GridContainer.get_children():
		z.queue_free()
	var list = []
	for _z in range(0, Global.INVENTORY['maximum_workers_shop']):
		var random = randi()%len(Global.WORKERS)
		while random in Global.INVENTORY['workers_contratados'] or random in list:
			random = randi()%len(Global.WORKERS)
		list.append(random)
		var node = preload("res://Scenes/Poor_obj_view.tscn").instance()
		node.TYPE = 'worker'
		node.OBJ = [random, Global.WORKERS[str(random)]['img'], Global.WORKERS[str(random)]['interval'], Global.WORKERS[str(random)]['hit'], Global.WORKERS[str(random)]['tax'], Global.WORKERS[str(random)]['pay']]
		$SHOP/GridContainer.add_child(node)

func _on_CLOSE_button_up():
	$SHOP.visible = false

func _on_ADD_WORKER_button_up():
	$SHOP.visible = true

func _on_ADD_WORKER2_button_up():
	$SHOP.visible = true

func _on_ADD_WORKER3_button_up():
	$SHOP.visible = true

func _on_ADD_WORKER4_button_up():
	$SHOP.visible = true
