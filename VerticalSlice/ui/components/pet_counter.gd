extends CanvasLayer

var pets_saved: int = 0
var total_pets: int = 0

@onready var counter_label: Label = $PanelContainer/HBoxContainer/SavedPetsLabel

func _ready() -> void:
	add_to_group("PetCounter")

	# Automatically count all rescue pets in this level
	total_pets = get_tree().get_nodes_in_group("RescuePet").size()

	update_counter()

func save_pet() -> void:
	pets_saved += 1
	update_counter()

func update_counter() -> void:
	counter_label.text = "Pets Saved: " + str(pets_saved) + " / " + str(total_pets)
