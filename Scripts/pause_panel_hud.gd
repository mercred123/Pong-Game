extends CanvasLayer

@onready var pause_menu: Control = $PauseMenu
@onready var option_panel: Control = $OptionPanel
@onready var pause_label: Label = $PauseIcon/Pause/MarginContainer2/Panel/Label

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	option_panel.visible = false
	pause_menu.visible = false
	
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().paused = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_menu"):
		if get_tree().paused:
			restart_game()
		else:
			pause_game()
	
	var keybind_settings = ConfigFileHandler.load_keybind_settings()
	var event = keybind_settings.get("pause_menu")
	
	if event is InputEventKey:
		var keycode = event.physical_keycode if event.physical_keycode != 0 else event.keycode
		pause_label.text = OS.get_keycode_string(keycode)
	else:
		pause_label.text = "Unassigned"

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

func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
