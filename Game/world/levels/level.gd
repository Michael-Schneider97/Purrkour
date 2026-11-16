class_name Level extends Node


@export var level: Node2D
@export var win_trigger: Area2D
@export var win_screen: Control
@export var pause_overlay: Control


func _ready() -> void:
	win_screen.hide()
	pause_overlay.hide()
	win_trigger.connect("level_won", _on_win_trigger_level_won)
	pause_overlay.connect("on_resume", _on_pause_overlay_resume)


func _on_win_trigger_level_won() -> void:
	win_screen.show()


func _on_pause_button_pressed() -> void:
	level.process_mode = Node.PROCESS_MODE_DISABLED
	pause_overlay.show()


func _on_pause_overlay_resume() -> void:
	level.process_mode = Node.PROCESS_MODE_INHERIT
	pause_overlay.hide()
