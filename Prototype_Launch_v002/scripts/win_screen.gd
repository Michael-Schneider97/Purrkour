extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide() 
	
func _show_win_scrn() -> void:
	show()
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
