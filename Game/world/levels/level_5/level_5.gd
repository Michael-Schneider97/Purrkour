extends Level


func _ready() -> void:
	super._ready()
	get_tree().debug_collisions_hint = true


func _exit_tree() -> void:
	super._ready()
	get_tree().debug_collisions_hint = false
