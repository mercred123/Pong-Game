extends CharacterBody2D

var win_size : Vector2
const START_SPEED : int = 500
const ACCEL : int = 50
const MAX_TRAIL_COUNT : int = 40
var speed : int
var dir : Vector2
const MAX_Y_VECTOR : float = 0.6

func _ready() -> void:
	win_size = get_viewport_rect().size
	
	$Line2D.top_level = true
	
	$TrailTimer.timeout.connect(update_trail)
	$TrailTimer.start()

func new_ball():
	position.x = win_size.x / 2
	position.y = randf_range(200, win_size.y - 200)
	speed = START_SPEED
	dir = random_direction()
	
	$Line2D.clear_points()

func _physics_process(delta: float) -> void:
	var collsion = move_and_collide(dir * speed * delta)
	var collider
	if collsion:
		collider = collsion.get_collider()
		if collider == $"../Player" or collider == $"../Robot":
			speed += ACCEL
			dir = new_direction(collider)
			$"../SFX_hit".play()
		else:
			dir = dir.bounce(collsion.get_normal())

func update_trail():
	if speed == 0:
		return
		
	if $Line2D.points.size() == MAX_TRAIL_COUNT:
		$Line2D.remove_point(0)
	$Line2D.add_point(global_position)

func random_direction():
	var new_dir := Vector2()
	new_dir.x = [1, -1].pick_random()
	new_dir.y = randf_range(-1, 1)
	return new_dir.normalized()

func new_direction(collider):
	var ball_y = position.y
	var pad_y = collider.position.y
	var dist = ball_y - pad_y
	var new_dir := Vector2()
	
	if dir.x > 0:
		new_dir.x = -1
	else:
		new_dir.x = 1
	new_dir.y = (dist / (collider.p_height / 2)) * MAX_Y_VECTOR
	return new_dir.normalized()
