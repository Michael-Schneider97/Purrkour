#extends Area2D
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#body_entered.connect(_on_body_entered)
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
#
#func _on_body_entered(body: Node2D) -> void:
	#if body.is_in_group("Player"):
		## This is where you would increase the "score"
		#queue_free()

extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):

		# Prevent this pet from triggering twice
		set_deferred("monitoring", false)

		# Find the saved-pet counter
		var counter = get_tree().get_first_node_in_group("PetCounter")

		# Add one to the saved-pet count
		if counter != null:
			counter.save_pet()

		# Remove the rescued pet
		queue_free()
