extends Camera2D

# Radius of the zone in the middle of the screen where the cam doesn't move
const DEAD_ZONE = 80

func _process(_delta):
	if Global.PLAYER_INFOS['max_health'] > 10:
		$GridContainer.columns = 10
	else:
		$GridContainer.columns = Global.PLAYER_INFOS['max_health']
	if len($GridContainer.get_children()) != Global.PLAYER_INFOS['actual_health'] and Global.PLAYER_INFOS['actual_health'] >= 0:
		if len($GridContainer.get_children()) < Global.PLAYER_INFOS['actual_health']:
			var textur = TextureRect.new()
			textur.texture = preload("res://Images/Others/Heart.png")
			$GridContainer.call_deferred("add_child", textur)
		else:
			for z in range(1, (Global.PLAYER_INFOS['max_health']-Global.PLAYER_INFOS['actual_health'])):
				$GridContainer.get_child(len($GridContainer.get_children())-z).texture = load("res://Images/Others/EmptyHeart.png")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: # If the mouse moved...
		var _target = event.position - get_viewport().size * 0.5	# Get the mouse position relative to the middle of the screen
		if _target.length() < DEAD_ZONE:	# If we're in the middle (dead zone)...
			self.position = Vector2(0,0)	# ... reset the camera to the middle (= center on player)
		else:
			# _target.normalized() is the direction in which to move
			# _target.length() - DEAD_ZONE is the distance the mouse is outside of the dead zone
			# 0.5 is an arbitrary scalar
			self.position = _target.normalized() * (_target.length() - DEAD_ZONE) * 0.5
