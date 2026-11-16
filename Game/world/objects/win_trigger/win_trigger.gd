extends Area2D

signal level_won

@export var level: int


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		level_won.emit()
		Saves.complete_level(level)
