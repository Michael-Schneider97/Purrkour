extends Area2D

@export var isActivated = false
var playerInRange = false
var player: Node2D = null
var useCollision = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if playerInRange and !isActivated and !useCollision:
		if event.is_action_pressed("interact"):
			press_button()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		playerInRange = true
		player = body
		if useCollision:
			press_button()
			
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		playerInRange = false
		body = null
		
func press_button() -> void:
	if isActivated:
		return
		
	isActivated = true
	$ButtonSound.play()
	print("Button Pressed")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
