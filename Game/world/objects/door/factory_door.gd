extends StaticBody2D

@export var target_object: Node

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

var is_open: bool = false

func _process(_delta: float) -> void:
	if is_instance_valid(target_object) and "isActivated" in target_object:
		var should_be_open: bool = target_object.isActivated
		
		if should_be_open != is_open:
			is_open = should_be_open
			toggle_door(is_open)

func toggle_door(open: bool) -> void:
	if open:
		$DoorSound.play()
		collision_shape.set_deferred("disabled", true)
		sprite.visible = false  
	else:
		collision_shape.set_deferred("disabled", false)
		sprite.visible = true 
