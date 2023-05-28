extends Node2D

func _on_Area2D_body_entered(body):
	if body.is_in_group("PLAYER") and Global.CHECKPOINT != global_position:
		Global.CHECKPOINT = self.global_position
		$AnimationPlayer.play("ReachedCheckpoint")
