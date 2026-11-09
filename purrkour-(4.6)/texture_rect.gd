extends Button

@onready var tree = $TextureRect

func _on_mouse_entered():
	tree.modulate = Color(0.8, 0.8, 0.8)

func _on_mouse_exited():
	tree.modulate = Color.WHITE

func _on_button_down():
	tree.modulate = Color(0.6, 0.6, 0.6)

func _on_button_up():
	tree.modulate = Color(0.8, 0.8, 0.8)
