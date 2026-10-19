extends RigidBody2D

@export var remote_path_node: Node
@onready var remote_transform = $RemoteTransform2D

@export var launch_power: float = 3
@export var max_drag_distance: float = 300

# trajectory line stuff
@export var max_points = 40
@export var time_step = .05

@onready var trajectory_line = $TrajectoryLine

var dragging := false
var drag_current := Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Setup line visual style
func _ready() -> void:
	remote_transform.remote_path = remote_path_node.get_path()
	add_to_group("Player")
	var img = preload("res://world/entities/dot.png")
	trajectory_line.hide()
	trajectory_line.width = 20.0
	trajectory_line.default_color = Color.YELLOW
	trajectory_line.texture_mode = Line2D.LINE_TEXTURE_TILE
	trajectory_line.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	trajectory_line.texture = img
	var line_gradient = Gradient.new()
	line_gradient.set_color(0, Color(1, 0.92, 0.01, 1.0))
	line_gradient.set_color(1, Color(1, 0.92, 0.01, 0.0))
	trajectory_line.gradient = line_gradient
	

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed && linear_velocity.y <= 0.01 && linear_velocity.y >= -0.01:
				dragging = true
				drag_current = get_global_mouse_position()

				freeze = true
				trajectory_line.show()
				queue_redraw()

			else:
				if dragging:
					trajectory_line.hide()
					launch()


	if event is InputEventMouseMotion and dragging:

		var mouse_pos = get_global_mouse_position()

		# start aiming from the visible cat sprite
		var cat_position = global_position

		var drag_vector = mouse_pos - cat_position

		# limit how far pull
		if drag_vector.length() > max_drag_distance:
			mouse_pos = cat_position + drag_vector.normalized() * max_drag_distance

		drag_current = mouse_pos
		_update_trajectory()
		queue_redraw()

func launch():

	var cat_position = global_position

	var launch_vector = cat_position - drag_current

	dragging = false
	freeze = false
	apply_central_impulse(launch_vector * launch_power)

	_update_trajectory()
	queue_redraw()

	
func _draw():

	if dragging:

		# where the visible cat sprite actually is
		var cat_local = to_local(global_position)

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
		#draw_line(
		#	cat_local,
		#	cat_local + (cat_local - mouse_local) * 6,
		#	Color.YELLOW,
		#	4.0
		#)


# Use kinematics to get curved line
func _update_trajectory() -> void:
	trajectory_line.clear_points()
	var cat_position = global_position
	var launch_vect = cat_position - drag_current
	
	var initial_velocity = (launch_vect * launch_power) / mass
	
	var grav_fixed = gravity * gravity_scale
	
	for i in range(max_points):
		var t = i * time_step
		var dx = initial_velocity.x * t
		var dy = (initial_velocity.y * t) + (.5 * grav_fixed * t * t)
		var point_offset = Vector2(dx, dy)
		
		var global_point_pos = cat_position + point_offset
		var local_point_pos = trajectory_line.to_local(global_point_pos)
		
		trajectory_line.add_point(local_point_pos)
