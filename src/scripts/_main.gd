extends Control

# --- Library --- #
func move_up(units: float):
	down.custom_minimum_size.y += units * move_sens
	top.custom_minimum_size.y -= units * move_sens
	map_centre()

func move_down(units: float):
	down.custom_minimum_size.y -= units * move_sens
	top.custom_minimum_size.y += units * move_sens
	map_centre()

func move_left(units: float):
	left.custom_minimum_size.x -= units * move_sens
	right.custom_minimum_size.x += units * move_sens
	map_centre()

func move_right(units: float):
	left.custom_minimum_size.x += units * move_sens
	right.custom_minimum_size.x -= units * move_sens
	map_centre()

func uniform_zoom_in():
	left.custom_minimum_size.x += 1 * zoom_sens
	right.custom_minimum_size.x += 1 * zoom_sens
	top.custom_minimum_size.y += 1 * zoom_sens
	down.custom_minimum_size.y += 1 * zoom_sens
	map_centre()

func uniform_zoom_out():
	left.custom_minimum_size.x -= 1 * zoom_sens
	right.custom_minimum_size.x -= 1 * zoom_sens
	top.custom_minimum_size.y -= 1 * zoom_sens
	down.custom_minimum_size.y -= 1 * zoom_sens
	map_centre()

func horizontal_gap_zoom_out():
	top.custom_minimum_size.y -= 1 * zoom_sens
	down.custom_minimum_size.y -= 1 * zoom_sens
	map_centre()

func horizontal_gap_zoom_in():
	top.custom_minimum_size.y += 1 * zoom_sens
	down.custom_minimum_size.y += 1 * zoom_sens
	map_centre()

func vertical_gap_zoom_out():
	left.custom_minimum_size.x -= 1 * zoom_sens
	right.custom_minimum_size.x -= 1 * zoom_sens
	map_centre()

func vertical_gap_zoom_in():
	left.custom_minimum_size.x += 1 * zoom_sens
	right.custom_minimum_size.x += 1 * zoom_sens
	map_centre()

func map_centre():
	centre.position.y = top.custom_minimum_size.y
	centre.position.x = left.custom_minimum_size.x
	centre.size.y = DisplayServer.window_get_size().y - down.custom_minimum_size.y - top.custom_minimum_size.y
	centre.size.x = DisplayServer.window_get_size().x - right.custom_minimum_size.x - left.custom_minimum_size.x

# --- Application --- #
@onready var left: ColorRect = $Left
@onready var right: ColorRect = $Right
@onready var top: ColorRect = $Top
@onready var down: ColorRect = $Down
@onready var centre: ColorRect = $Centre

var move_sens: float = 1
var zoom_sens: float = 1

var pause: bool :
	set(value):
		if value == true:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif value == false:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		pause = value

func _ready() -> void:
	left.custom_minimum_size.x = 64
	right.custom_minimum_size.x = 64
	top.custom_minimum_size.y = 64
	down.custom_minimum_size.y = 64
	map_centre()
	pause = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.is_pressed():
			pause = !pause
	
	if not pause:
		if event is InputEventKey:
			if event.keycode == KEY_UP or event.keycode == KEY_K:
				if event.alt_pressed:
					if event.ctrl_pressed:
						horizontal_gap_zoom_in()
					elif event.shift_pressed:
						vertical_gap_zoom_in()
					else:
						uniform_zoom_in()
				else:
					move_up(1)
			if event.keycode == KEY_DOWN or event.keycode == KEY_J:
				if event.alt_pressed:
					if event.ctrl_pressed:
						horizontal_gap_zoom_out()
					elif event.shift_pressed:
						vertical_gap_zoom_out()
					else:
						uniform_zoom_out()
				else:
					move_down(1)
			if event.keycode == KEY_LEFT or event.keycode == KEY_H:
				move_left(1)
			if event.keycode == KEY_RIGHT or event.keycode == KEY_L:
				move_right(1)
		elif event is InputEventMouseMotion:
			if event.ctrl_pressed:
				if event.relative.y < 0:
					move_up(-event.relative.y)
				if event.relative.y > 0:
					move_down(event.relative.y)
			elif event.shift_pressed:
				if event.relative.x < 0:
					move_left(-event.relative.x)
				if event.relative.x > 0:
					move_right(event.relative.x)
			else:
				if event.relative.x < 0:
					move_left(-event.relative.x)
				if event.relative.x > 0:
					move_right(event.relative.x)
				if event.relative.y < 0:
					move_up(-event.relative.y)
				if event.relative.y > 0:
					move_down(event.relative.y)
		elif event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if event.ctrl_pressed:
					horizontal_gap_zoom_in()
				elif event.shift_pressed:
					vertical_gap_zoom_in()
				else:
					uniform_zoom_in()
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if event.ctrl_pressed:
					horizontal_gap_zoom_out()
				elif event.shift_pressed:
					vertical_gap_zoom_out()
				else:
					uniform_zoom_out()
