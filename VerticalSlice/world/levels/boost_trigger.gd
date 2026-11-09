extends Area2D

@onready var boost_trigger_sound := $AudioStreamPlayer2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var player: Player = body
		player.boost()
		boost_trigger_sound.play()
