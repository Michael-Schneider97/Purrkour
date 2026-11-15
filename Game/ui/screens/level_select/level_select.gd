extends Control

@export_file("*tscn") var main_menu_screen: String
@export_file("*tscn") var level_1_scene: String
@export_file("*tscn") var level_2_scene: String
@export_file("*tscn") var level_3_scene: String
@export_file("*tscn") var level_4_scene: String
@export_file("*tscn") var level_5_scene: String


func _on_level_1_button_pressed():
	get_tree().change_scene_to_file(level_1_scene)


func _on_level_2_button_pressed():
	get_tree().change_scene_to_file(level_2_scene)


func _on_level_3_button_pressed():
	get_tree().change_scene_to_file(level_3_scene)


func _on_level_4_button_pressed():
	get_tree().change_scene_to_file(level_4_scene)


func _on_level_5_button_pressed():
	get_tree().change_scene_to_file(level_5_scene)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(main_menu_screen)
