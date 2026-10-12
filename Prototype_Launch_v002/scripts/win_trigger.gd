extends Area2D

@onready var win_screen = $"../WinScreen"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	print("Something collided! Object name: ", body.name)
	if body.is_in_group("Player"):
		win_screen.show()
		
		
