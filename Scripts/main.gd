extends Sprite2D

@onready var hud: CanvasLayer = $Hud

@export var goalParticles: PackedScene

var score := [0, 0]#Player / Robot
var PADDLE_SPEED : int = 500

var shake_strength: float = 0.0
var shake_decay: float = 5.0
var original_position: Vector2

func _ready() -> void:
	original_position = position
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func apply_shake(strength: float):
	var video_settings = ConfigFileHandler.load_video_settings()
	var can_shake = video_settings.screen_shake
	
	if can_shake:
		shake_strength = strength

func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_decay * delta)
		position = original_position + Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
	else:
		position = original_position

func particle_start(pos: Vector2):
	var _particle = goalParticles.instantiate()
	_particle.position = pos
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)

func _on_ball_timer_timeout() -> void:
	$Ball.new_ball()

func _on_score_left_body_entered(body: Node2D) -> void:
	score[1] += 1
	hud.get_node("CenterContainer/HBoxContainer/Left").text = str(score[1])
	$BallTimer.start()
	$ScoreLeft/AnimationPlayer.play("Goal")
	apply_shake(5.0)
	particle_start(body.position)
	#$SFX_goal.play()

func _on_score_right_body_entered(body: Node2D) -> void:
	score[0] += 1
	hud.get_node("CenterContainer/HBoxContainer/Right").text = str(score[0])
	$BallTimer.start()
	$ScoreRight/AnimationPlayer.play("Goal")
	apply_shake(5.0)
	particle_start(body.position)
	#$SFX_goal.play()
