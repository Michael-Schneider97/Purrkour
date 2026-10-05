extends RigidBody2D

@export var launch_power: float = 12.0
@export var max_drag_distance: float = 150.0

var dragging := false
var drag_current := Vector2.ZERO


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed && linear_velocity.y <= 0.01 && linear_velocity.y >= -0.01:
				dragging = true
				drag_current = get_global_mouse_position()

				freeze = true
				queue_redraw()

			else:
				if dragging:
					launch()


	if event is InputEventMouseMotion and dragging:

		var mouse_pos = get_global_mouse_position()

		# start aiming from the visible cat sprite
		var cat_position = $Sprite2D.global_position

		var drag_vector = mouse_pos - cat_position

		# limit how far pull
		if drag_vector.length() > max_drag_distance:
			mouse_pos = cat_position + drag_vector.normalized() * max_drag_distance

		drag_current = mouse_pos

		queue_redraw()


func launch():

	var cat_position = $Sprite2D.global_position

	var launch_vector = cat_position - drag_current

	dragging = false
	freeze = false

	apply_central_impulse(launch_vector * launch_power)

	queue_redraw()


func _draw():

	if dragging:

		# where the visible cat sprite actually is
		var cat_local = to_local($Sprite2D.global_position)

		# where the mouse is
		var mouse_local = to_local(drag_current)

		# how far you're pulling
		draw_line(
			cat_local,
			mouse_local,
			Color.RED,
			12.0
		)
		
		
		# how far you're pulling
		draw_line(
			cat_local,
			cat_local + (cat_local - mouse_local) * 6,
			Color.YELLOW,
			4.0
		)
