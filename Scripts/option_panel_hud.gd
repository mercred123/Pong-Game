extends CanvasLayer

@onready var pause_menu: Panel = $PauseMenu
@onready var option_panel: Panel = $OptionPanel
@onready var option_button: OptionButton = $OptionPanel/Options/ScrollContainer/CenterContainer/VBoxContainer/WindowOptions/MarginContainer/VBoxContainer/OptionButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	option_panel.visible = false
	pause_menu.visible = false
	
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().paused = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			restart_game()
		else:
			pause_game()

func pause_game() -> void:
	pause_menu.visible = true
	option_panel.visible = false
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func restart_game() -> void:
	get_tree().paused = false
	
	pause_menu.visible = false
	option_panel.visible = false
	
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _on_start_pressed() -> void:
	restart_game()

func _on_options_pressed() -> void:
	option_panel.visible = true
	pause_menu.visible = false

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	option_panel.visible = false
	pause_menu.visible = true

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
