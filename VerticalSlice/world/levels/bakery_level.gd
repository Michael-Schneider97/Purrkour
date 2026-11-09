extends Node2D

func _ready() -> void:
	get_tree().debug_collisions_hint = true

func _exit_tree() -> void:
	get_tree().debug_collisions_hint = false
