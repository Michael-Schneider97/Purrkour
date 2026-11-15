extends Control

@export_file("*.tscn") var level_1_scene: String
@export_file("*.tscn") var level_select_screen: String


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(level_1_scene)


func _on_levels_button_pressed() -> void:
	get_tree().change_scene_to_file(level_select_screen)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
