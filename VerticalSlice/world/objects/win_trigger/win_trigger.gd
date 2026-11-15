extends Area2D

signal level_won


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		level_won.emit()
