extends CanvasLayer

var pets_saved: int = 0
var total_pets: int = 4

@onready var counter_label: Label = $PanelContainer/HBoxContainer/SavedPetsLabel

func _ready() -> void:
	add_to_group("PetCounter")
	update_counter()

func save_pet() -> void:
	pets_saved += 1
	update_counter()

func update_counter() -> void:
	counter_label.text = "Pets Saved: " + str(pets_saved) + " / " + str(total_pets)
