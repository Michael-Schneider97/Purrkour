extends Control

@export_file var next_level_scene: String
@export_file var main_menu_screen: String
@export_file var level_select_screen: String


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file(main_menu_screen)


func _on_next_button_pressed() -> void:
	if !next_level_scene:
		get_tree().change_scene_to_file(level_select_screen)
	else:
		get_tree().change_scene_to_file(next_level_scene)
