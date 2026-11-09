extends CanvasLayer

@export var next_level: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide() 
	
func _show_win_scrn() -> void:
	show()
	
func _on_quit_button_pressed() -> void:
	# get_tree().quit()
	get_tree().change_scene_to_file("res://ui/screens/main_menu/main_men.tscn")

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_next_button_pressed() -> void:
	if(!next_level):
		get_tree().change_scene_to_file("res://ui/screens/level_select/levelselect.tscn")
	else:
		get_tree().change_scene_to_packed(next_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
