extends Sprite2D

@onready var hud: CanvasLayer = $Hud

var score := [0, 0]#Player / Robot
var PADDLE_SPEED : int = 500

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _on_ball_timer_timeout() -> void:
	$Ball.new_ball()

func _on_score_left_body_entered(_body: Node2D) -> void:
	score[1] += 1
	hud.get_node("CenterContainer/HBoxContainer/Left").text = str(score[1])
	$BallTimer.start()
	$ScoreLeft/AnimationPlayer.play("Goal")
	#$SFX_goal.play()

func _on_score_right_body_entered(_body: Node2D) -> void:
	score[0] += 1
	hud.get_node("CenterContainer/HBoxContainer/Right").text = str(score[0])
	$BallTimer.start()
	$ScoreRight/AnimationPlayer.play("Goal")
	#$SFX_goal.play()
