extends Control


@export_file("*tscn") var main_menu_screen: String

signal on_resume


func _on_resume_button_pressed() -> void:
	on_resume.emit()


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(main_menu_screen)
