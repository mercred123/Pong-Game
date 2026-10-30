extends StaticBody2D

var ball_pos : Vector2
var dist : float
var move_by : float
var win_height : int
var p_height : int

func _ready() -> void:
	@warning_ignore("narrowing_conversion")
	win_height = get_viewport_rect().size.y
	p_height = $ColorRect.get_size().y

func _physics_process(delta: float) -> void:
	ball_pos = $"../Ball".position
	dist = position.y - ball_pos.y
	
	if abs(dist) > get_parent().PADDLE_SPEED * delta:
		move_by = get_parent().PADDLE_SPEED * delta * (dist / abs(dist))
	else:
		move_by = dist
	
	position.y -= move_by
	
	@warning_ignore("integer_division")
	position.y = clamp(position.y, p_height / 2, win_height - p_height /2)
