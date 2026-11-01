extends StaticBody2D

@export var hud: CanvasLayer

var dificulty: Dictionary = {
	# easy
	1: {
		"speed_multiplicator": 0.75,
		"time_reaction": 0.2,
		"anticipation": false
	},
	# medium
	2: {
		"speed_multiplicator": 0.95,
		"time_reaction": 0.05,
		"anticipation": false
	},
	# hard
	3: {
		"speed_multiplicator": 1,
		"time_reaction": 0.0,
		"anticipation": true
	},
}

var ball_pos : Vector2
var dist : float
var move_by : float
var win_height : int
var p_height : int

var actual_difficulty: int = 1

var reaction_timer: float = 0.0
var target_ball_y: float = 0.0

func _ready() -> void:
	hud.get_node("DificultyPanel").actual_difficulty.connect(_actual_difficulty)
	
	@warning_ignore("narrowing_conversion")
	win_height = get_viewport_rect().size.y
	p_height = $ColorRect.get_size().y
	target_ball_y = position.y

func _actual_difficulty(index: int):
	actual_difficulty = index
	reaction_timer = 0.0

func _physics_process(delta: float) -> void:
	var current_diff = dificulty[actual_difficulty]
	var current_speed = get_parent().PADDLE_SPEED * current_diff["speed_multiplicator"]
	var time_reaction = current_diff["time_reaction"]
	
	var ball = $"../Ball"
	var ball_velocity = ball.dir * ball.speed
	
	if current_diff["anticipation"]:
		if ball_velocity.x > 0:
			var distance_x = abs(position.x - ball.position.x)
			var time_to_reach = distance_x / abs(ball_velocity.x)
			
			target_ball_y = ball.position.y + (ball_velocity.y * time_to_reach)
			target_ball_y = clamp(target_ball_y, p_height / 2.0, win_height - p_height / 2.0)
		else:
			target_ball_y = win_height / 2.0
	else:
		if time_reaction > 0.0:
			reaction_timer += delta
			if reaction_timer >= time_reaction:
				target_ball_y = ball.position.y
				reaction_timer = 0.0
			
			var real_ball_y = ball.position.y
			target_ball_y = lerp(target_ball_y, real_ball_y, delta * (1.0 / time_reaction))
		else:
			target_ball_y = ball.position.y
	
	dist = position.y - target_ball_y
	
	if abs(dist) > current_speed * delta:
		move_by = current_speed * delta * (dist / abs(dist))
	else:
		move_by = dist
	
	position.y -= move_by
	
	@warning_ignore("integer_division")
	position.y = clamp(position.y, p_height / 2, win_height - p_height / 2)
