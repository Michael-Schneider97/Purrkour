extends RigidBody2D
@export var rescue_sound: AudioStream = preload("res://world/entities/pet/collect_pets.mp3")
var is_rescued = false

func _enter_tree() -> void:
	add_to_group("RescuePet")

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
	if body.is_in_group("Player") and not is_rescued:
		is_rescued = true

		var audio = AudioStreamPlayer.new()
		audio.stream = rescue_sound
		get_parent().add_child(audio)
		audio.play()
		audio.finished.connect(audio.queue_free)

		# prevent this pet from triggering twice
		$Area2D.set_deferred("monitoring", false)

		# find the saved-pet counter
		var counter = get_tree().get_first_node_in_group("PetCounter")

		# add one to the saved-pet count
		if counter != null:
			counter.save_pet()

		queue_free()
