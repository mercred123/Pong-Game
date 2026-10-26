extends StaticBody2D

var win_height : int
var p_height : int

func _ready() -> void:
	@warning_ignore("narrowing_conversion")
	win_height = get_viewport_rect().size.y
	p_height = $Skins/DefaultSkin.get_size().y

func _process(delta: float) -> void:
	if Input.is_action_pressed("up"):
		position.y -= get_parent().PADDLE_SPEED * delta
	elif Input.is_action_pressed("down"):
		position.y += get_parent().PADDLE_SPEED * delta
	
	@warning_ignore("integer_division")
	position.y = clamp(position.y, p_height / 2, win_height - p_height /2)
