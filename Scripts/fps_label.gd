extends Label

var can_show_fps: bool

@export var optionPanel: Control

func _ready() -> void:
	optionPanel.show_fps.connect(_fps_show_toggle)

func _fps_show_toggle():
	can_show_fps = !can_show_fps

func _process(_delta: float) -> void:
	if can_show_fps == true:
		self.visible = true
		self.text = str(int(Engine.get_frames_per_second())) + "fps"
	else:
		self.visible = false
