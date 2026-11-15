class_name Level extends Node


@export var win_trigger: Area2D
@export var win_screen: Control


func _ready() -> void:
	win_screen.hide()
	win_trigger.connect("level_won", _on_win_trigger_level_won)


func _on_win_trigger_level_won() -> void:
	win_screen.show()
