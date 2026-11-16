extends Node2D

@onready var traversal_tutorial = $Traversal
@onready var save_pet_tutorial: Node2D = $SavePet
@onready var first_pet_collection_area: Area2D = $Pet/Area2D

func _ready() -> void:
	first_pet_collection_area.body_entered.connect(_on_first_pet_collected)

func _process(_delta: float) -> void:
	if traversal_tutorial.done and not save_pet_tutorial.visible:
		save_pet_tutorial.show()

func _on_first_pet_collected(body: Node2D) -> void:
	if body.is_in_group("Player"):
		set_process(false)
		save_pet_tutorial.queue_free()
