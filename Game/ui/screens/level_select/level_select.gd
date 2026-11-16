extends Control

@export_file("*tscn") var main_menu_screen: String
@export_file("*tscn") var level_1_scene: String
@export_file("*tscn") var level_2_scene: String
@export_file("*tscn") var level_3_scene: String
@export_file("*tscn") var level_4_scene: String
@export_file("*tscn") var level_5_scene: String

@onready var level_1_button := $Level1Button
@onready var level_2_button := $Level2Button
@onready var level_3_button := $Level3Button
@onready var level_4_button := $Level4Button
@onready var level_5_button := $Level5Button

@onready var level_1_lock := $Level1Button/Lock
@onready var level_2_lock := $Level2Button/Lock
@onready var level_3_lock := $Level3Button/Lock
@onready var level_4_lock := $Level4Button/Lock
@onready var level_5_lock := $Level5Button/Lock


func _ready() -> void:
	if Saves.get_level_state(1) == Saves.LevelProgress.LOCKED:
		level_1_button.disabled = true
	else:
		level_1_lock.hide()
	if Saves.get_level_state(2) == Saves.LevelProgress.LOCKED:
		level_2_button.disabled = true
	else:
		level_2_lock.hide()
	if Saves.get_level_state(3) == Saves.LevelProgress.LOCKED:
		level_3_button.disabled = true
	else:
		level_3_lock.hide()
	if Saves.get_level_state(4) == Saves.LevelProgress.LOCKED:
		level_4_button.disabled = true
	else:
		level_4_lock.hide()
	if Saves.get_level_state(5) == Saves.LevelProgress.LOCKED:
		level_5_button.disabled = true
	else:
		level_5_lock.hide()


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
