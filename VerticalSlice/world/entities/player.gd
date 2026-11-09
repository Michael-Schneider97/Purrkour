
class_name Player
extends RigidBody2D

@export var remote_path_node: Camera2D
@onready var remote_transform = $RemoteTransform2D

@export var launch_power: float = 3
@export var max_drag_distance: float = 300

# Trajectory line stuff
@export var max_points = 40
@export var time_step = .05

@onready var trajectory_line = $TrajectoryLine

var dragging := false
var drag_current := Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var boost_timer: Timer = $BoostTimer
var boost_orig_zoom := Vector2(1, 1)

# Cat animations
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ground_check: RayCast2D = $GroundCheck


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

	# Start with idle animation
	animated_sprite.play("idle")


# Update cat animation based on movement
func _physics_process(_delta: float) -> void:

	# Stay idle while preparing a launch
	if dragging:
		play_cat_animation("idle")
		return

	# Cat is standing on a platform
	if ground_check.is_colliding() and linear_velocity.y >= -20.0 and linear_velocity.y <= 35.0:
		play_cat_animation("idle")

	# Cat is moving upward
	elif linear_velocity.y < -20.0:
		play_cat_animation("jump start")

	# Cat is falling downward
	elif linear_velocity.y > 20.0:
		play_cat_animation("jump fall")


# Prevent animation from restarting every frame
func play_cat_animation(anim_name: String) -> void:
	if animated_sprite.animation != anim_name:
		animated_sprite.play(anim_name)


func boost():
	if boost_timer.is_stopped():
		launch_power = 3.5
		boost_orig_zoom = remote_path_node.zoom
		remote_path_node.zoom = boost_orig_zoom / 1.5

	boost_timer.start()


func _on_boost_timer_timeout() -> void:
	launch_power = 3
	remote_path_node.zoom = boost_orig_zoom
	boost_timer.stop()


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed and linear_velocity.y <= 0.01 and linear_velocity.y >= -0.01:
				dragging = true
				drag_current = get_global_mouse_position()

				freeze = true
				trajectory_line.show()

				# Idle while aiming
				play_cat_animation("idle")

				queue_redraw()

			elif not event.pressed and dragging:
				trajectory_line.hide()
				launch()

	if event is InputEventMouseMotion and dragging:

		var mouse_pos = get_global_mouse_position()
		var cat_position = global_position
		var drag_vector = mouse_pos - cat_position

		# Limit how far the player can pull
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

	# Start jump animation
	animated_sprite.play("jump start")

	# Face the direction of launch
	if abs(launch_vector.x) > 1.0:
		animated_sprite.flip_h = launch_vector.x < 0.0

	apply_central_impulse(launch_vector * launch_power)

	_update_trajectory()
	queue_redraw()


func _draw():

	if dragging:

		var cat_local = to_local(global_position)
		var mouse_local = to_local(drag_current)

		draw_line(
			cat_local,
			mouse_local,
			Color.RED,
			12.0
		)


# Use kinematics to get curved trajectory line
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
