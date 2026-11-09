extends StaticBody2D

var win_height: int
var p_height: int

# Touch
var touch_active := false
var touch_index := -1
var touch_offset := 0.0
var last_touch_y := 0.0
var last_touch_time := 0

# Movement
var target_y := 0.0
var current_velocity := 0.0

# Prediction
var finger_velocity := 0.0

# Settings
const TOUCH_MAX_SPEED := 1400.0
const ACCELERATION := 5000.0
const DECELERATION := 7000.0
const DISTANCE_GAIN := 12.0
const DEADZONE := 3.0

const PREDICTION_TIME := 0.045
const MAX_PREDICTION := 60.0
const FINGER_TIMEOUT := 80

func _ready() -> void:
	@warning_ignore("narrowing_conversion")
	win_height = get_viewport_rect().size.y
	p_height = $Skins/DefaultSkin.get_size().y
	
	target_y = position.y

func _input(event: InputEvent) -> void:
	if not OS.has_feature("mobile"):
		return
	
	if event is InputEventScreenTouch:
		if event.pressed:
			if event.position.x < get_viewport_rect().size.x / 2:
				touch_active = true
				touch_index = event.index
				touch_offset = position.y - event.position.y
				last_touch_y = event.position.y
				target_y = position.y
				finger_velocity = 0.0
				last_touch_time = Time.get_ticks_msec()
		elif event.index == touch_index:
			touch_active = false
			touch_index = -1
			finger_velocity = 0.0
	elif event is InputEventScreenDrag:
		if touch_active and event.index == touch_index:
			var movement: float = event.position.y - last_touch_y
			if abs(movement) > DEADZONE:
				finger_velocity = event.velocity.y
				target_y = event.position.y + touch_offset
				last_touch_y = event.position.y
				last_touch_time = Time.get_ticks_msec()

func _process(delta: float) -> void:
	if OS.has_feature("mobile"):
		if Time.get_ticks_msec() - last_touch_time > FINGER_TIMEOUT:
			finger_velocity = 0.0
		var prediction := clampf(
			finger_velocity * PREDICTION_TIME,
			-MAX_PREDICTION,
			MAX_PREDICTION
		)
		var predicted_y := target_y + prediction
		var distance := predicted_y - position.y
		var desired_velocity := 0.0
		
		if touch_active and abs(distance) > DEADZONE:
			desired_velocity = clampf(
				distance * DISTANCE_GAIN,
				-TOUCH_MAX_SPEED,
				TOUCH_MAX_SPEED
			)
		var acceleration := ACCELERATION
		if abs(desired_velocity) < abs(current_velocity):
			acceleration = DECELERATION
		current_velocity = move_toward(
			current_velocity,
			desired_velocity,
			acceleration * delta
		)
		var movement := current_velocity * delta
		if abs(distance) <= abs(movement) + DEADZONE and desired_velocity != 0.0:
			position.y = predicted_y
			current_velocity = 0.0
		else:
			position.y += movement
	else:
		if Input.is_action_pressed("up"):
			position.y -= get_parent().PADDLE_SPEED * delta
		elif Input.is_action_pressed("down"):
			position.y += get_parent().PADDLE_SPEED * delta
	position.y = clampf(
		position.y,
		p_height / 2.0,
		win_height - p_height / 2.0
	)
