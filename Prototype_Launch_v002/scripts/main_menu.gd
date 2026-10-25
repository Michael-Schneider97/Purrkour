extends Control
## Purrkour main menu for Godot 4.x.
## Set GAME_SCENE to your existing level scene (or use the exported inspector value).

@export_file("*.tscn") var game_scene: String = "res://game.tscn"

var play_button: Button
var quit_button: Button
var title_label: Label
var subtitle_label: Label
var _cloud_offset: float = 0.0

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	_build_ui()
	_responsive_layout()
	get_viewport().size_changed.connect(_responsive_layout)

func _process(delta: float) -> void:
	_cloud_offset = fmod(_cloud_offset + delta * 7.0, 900.0)
	queue_redraw()

func _build_ui() -> void:
	title_label = Label.new()
	title_label.text = "PURRKOUR"
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 66)
	title_label.add_theme_color_override("font_color", Color("49345f"))
	title_label.add_theme_color_override("font_shadow_color", Color("fdf1d8"))
	title_label.add_theme_constant_override("shadow_offset_x", 3)
	title_label.add_theme_constant_override("shadow_offset_y", 4)
	add_child(title_label)

	subtitle_label = Label.new()
	subtitle_label.text = "A little cat. A big climb."
	subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle_label.add_theme_font_size_override("font_size", 21)
	subtitle_label.add_theme_color_override("font_color", Color("695270"))
	add_child(subtitle_label)

	play_button = _make_button("PLAY", Color("f2a8a1"), Color("573b61"))
	play_button.pressed.connect(_on_play_pressed)
	add_child(play_button)

	quit_button = _make_button("QUIT", Color("fff5dc"), Color("573b61"))
	quit_button.pressed.connect(func(): get_tree().quit())
	add_child(quit_button)

	var hint := Label.new()
	hint.name = "Footer"
	hint.text = "Aim  •  Launch  •  Climb"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 16)
	hint.add_theme_color_override("font_color", Color("745b7b"))
	add_child(hint)

func _make_button(button_text: String, bg: Color, fg: Color) -> Button:
	var button := Button.new()
	button.text = button_text
	button.focus_mode = Control.FOCUS_ALL
	button.add_theme_font_size_override("font_size", 27)
	button.add_theme_color_override("font_color", fg)
	button.add_theme_color_override("font_hover_color", fg)
	button.add_theme_color_override("font_pressed_color", fg)
	for state in ["normal", "hover", "pressed", "focus"]:
		var style := StyleBoxFlat.new()
		style.bg_color = bg.lightened(0.12) if state == "hover" else (bg.darkened(0.08) if state == "pressed" else bg)
		style.set_corner_radius_all(22)
		style.set_border_width_all(3)
		style.border_color = Color("5e4666")
		style.shadow_color = Color(0.28, 0.2, 0.33, 0.24)
		style.shadow_size = 5 if state != "pressed" else 1
		style.content_margin_left = 20
		style.content_margin_right = 20
		button.add_theme_stylebox_override(state, style)
	return button

func _responsive_layout() -> void:
	var w := size.x
	var h := size.y
	var menu_w := minf(w * 0.74, 370.0)
	var title_y := h * 0.18
	var title_size := 66 if w > 540 else 43
	title_label.add_theme_font_size_override("font_size", title_size)
	title_label.position = Vector2(w * 0.06, title_y)
	title_label.size = Vector2(w * 0.88, 90)
	subtitle_label.position = Vector2(w * 0.05, title_y + 84)
	subtitle_label.size = Vector2(w * 0.9, 38)
	play_button.position = Vector2((w - menu_w) / 2.0, h * 0.53)
	play_button.size = Vector2(menu_w, 68)
	quit_button.position = Vector2((w - menu_w) / 2.0, h * 0.53 + 84)
	quit_button.size = Vector2(menu_w, 68)
	get_node("Footer").position = Vector2(w * 0.1, h - 48)
	get_node("Footer").size = Vector2(w * 0.8, 28)
	queue_redraw()

func _on_play_pressed() -> void:
	if ResourceLoader.exists(game_scene):
		get_tree().change_scene_to_file(game_scene)
	else:
		push_warning("Purrkour: level scene not found: " + game_scene + ". Set 'Game Scene' in the MainMenu inspector.")
		play_button.text = "SET GAME SCENE FIRST"

func _draw() -> void:
	var w := size.x
	var h := size.y
	# Sky
	draw_rect(Rect2(Vector2.ZERO, size), Color("d9edee"))
	draw_rect(Rect2(0, h * 0.61, w, h * 0.39), Color("d0e7d4"))
	# Sun
	draw_circle(Vector2(w * 0.83, h * 0.16), minf(w, h) * 0.09, Color("fff2c6"))
	# Floating clouds
	for i in 4:
		var x := fposmod(i * 275.0 + _cloud_offset, w + 250.0) - 125.0
		var y := h * (0.12 + (i % 3) * 0.11)
		_draw_cloud(Vector2(x, y), 0.8 + float(i % 2) * 0.28)
	# Far hills
	_draw_hill(Vector2(w * 0.06, h * 0.91), w * 0.6, h * 0.28, Color("afcfba"))
	_draw_hill(Vector2(w * 0.84, h * 0.95), w * 0.72, h * 0.3, Color("a2c4ae"))
	# Trees frame the screen, with branches for the cat to climb.
	_draw_tree(Vector2(w * 0.07, h * 1.05), 0.9, true)
	_draw_tree(Vector2(w * 0.95, h * 1.08), 1.1, false)
	# Cute little cat watching the branches from the foreground
	_draw_cat(Vector2(w * 0.18, h * 0.78), clampf(w / 750.0, 0.65, 1.15))

func _draw_cloud(p: Vector2, scale_factor: float) -> void:
	var c := Color("fffdf5")
	draw_circle(p, 24 * scale_factor, c)
	draw_circle(p + Vector2(27, -7) * scale_factor, 33 * scale_factor, c)
	draw_circle(p + Vector2(59, 0) * scale_factor, 24 * scale_factor, c)
	draw_rect(Rect2(p + Vector2(-1, 0) * scale_factor, Vector2(62, 21) * scale_factor), c)

func _draw_hill(center: Vector2, width: float, height: float, color: Color) -> void:
	draw_ellipse_approx(center, width, height, color)

func draw_ellipse_approx(center: Vector2, width: float, height: float, color: Color) -> void:
	var points := PackedVector2Array()
	for i in range(37):
		var angle := TAU * i / 36.0
		points.append(center + Vector2(cos(angle) * width * 0.5, sin(angle) * height * 0.5))
	draw_colored_polygon(points, color)

func _draw_tree(base: Vector2, scale_factor: float, left: bool) -> void:
	var direction := 1.0 if left else -1.0
	var trunk_color := Color("98715e")
	var branch_color := Color("ab8469")
	draw_line(base, base + Vector2(0, -610) * scale_factor, trunk_color, 59 * scale_factor, true)
	for i in 4:
		var start := base + Vector2(0, -(175 + i * 120)) * scale_factor
		var end := start + Vector2(170 * direction, -35) * scale_factor
		draw_line(start, end, branch_color, 23 * scale_factor, true)
		draw_circle(end + Vector2(-26 * direction, -24) * scale_factor, 61 * scale_factor, Color("91bba0"))
		draw_circle(end + Vector2(20 * direction, -44) * scale_factor, 48 * scale_factor, Color("a4c8ab"))
		draw_circle(end + Vector2(-50 * direction, -43) * scale_factor, 42 * scale_factor, Color("b5d4b3"))

func _draw_cat(p: Vector2, s: float) -> void:
	var dark := Color("564360")
	var blush := Color("e99a9f")
	# Tail and body
	draw_arc(p + Vector2(-35, 15) * s, 34 * s, -PI * 0.3, PI * 1.08, 22, dark, 14 * s, true)
	draw_ellipse_approx(p + Vector2(0, 38) * s, 77 * s, 88 * s, dark)
	# Pointed ears
	draw_colored_polygon(PackedVector2Array([p + Vector2(-35, -33) * s, p + Vector2(-34, -86) * s, p + Vector2(-4, -52) * s]), dark)
	draw_colored_polygon(PackedVector2Array([p + Vector2(7, -52) * s, p + Vector2(38, -86) * s, p + Vector2(34, -32) * s]), dark)
	draw_ellipse_approx(p + Vector2(0, -32) * s, 90 * s, 74 * s, dark)
	# Eyes, nose and cheeks
	draw_circle(p + Vector2(-18, -37) * s, 5 * s, Color("fff5dc"))
	draw_circle(p + Vector2(18, -37) * s, 5 * s, Color("fff5dc"))
	draw_circle(p + Vector2(-27, -19) * s, 7 * s, blush)
	draw_circle(p + Vector2(27, -19) * s, 7 * s, blush)
	draw_circle(p + Vector2(0, -20) * s, 4 * s, Color("ffd2bc"))
