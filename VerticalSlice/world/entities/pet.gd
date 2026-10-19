extends RigidBody2D

@export_enum("Left and Right", "Hop") var mode: String = "Hop"

@onready var hop_timer = $HopTimer
@onready var left_detector = $LeftDetector
@onready var right_detector = $RightDetector

@onready var left = true


func _on_hop_timer_timeout() -> void:
	if mode == "Hop":
		apply_central_impulse(Vector2(0, -200))

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if mode == "Left and Right":
		if left:
			state.linear_velocity.x = -300
		else:
			state.linear_velocity.x = 300


func _on_right_detector_2_body_entered(_body: Node2D) -> void:
	left = true


func _on_left_detector_body_entered(_body: Node2D) -> void:
	left = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# Prevent this pet from triggering twice
		set_deferred("monitoring", false)

		# Find the saved-pet counter
		var counter = get_tree().get_first_node_in_group("PetCounter")

		# Add one to the saved-pet count
		if counter != null:
			counter.save_pet()
		queue_free()
