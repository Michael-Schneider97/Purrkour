extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# there is probably a more dynamic way to do this but its fine lol
func _on_select_park():
	get_tree().change_scene_to_file("res://world/levels/level_001_park/level_002_park.tscn")

func _on_select_factory():
	get_tree().change_scene_to_file("res://world/levels/level_002_factory/level_003_ab_factry.tscn")

func _on_select_fire_escape():
	get_tree().change_scene_to_file("res://world/levels/level_003_building/fire_escape_level.tscn")

func _on_select_bakery():
	get_tree().change_scene_to_file("res://world/levels/level_004_bakery/bakery_level.tscn")

func _on_select_tower():
	get_tree().change_scene_to_file("res://world/levels/level_005_tower/level_006_tower.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/screens/main_menu/main_men.tscn")
