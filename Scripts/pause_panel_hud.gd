extends CanvasLayer

@onready var pause_menu: Control = $PauseMenu
@onready var option_panel: Control = $OptionPanel
@onready var pause_label: Label = $PauseIcon/Pause/MarginContainer2/Panel/Label
@onready var dificulty_panel: Control = $DificultyPanel

func _ready() -> void:
	option_panel.get_node("OptionPanel/Options/ScrollContainer/CenterContainer/VBoxContainer/ControlsOptions/VBoxContainer/CenterContainer/MarginContainer/VBoxContainer/VBoxContainer/Pause/HBoxContainer/PauseButton").update_pause_label.connect(update_pause_text)
	update_pause_text()
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	option_panel.visible = false
	pause_menu.visible = false
	
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().paused = false

func update_pause_text() -> void:
	var keybind_settings = ConfigFileHandler.load_keybinds()
	var event = keybind_settings.get("pause_menu")
	
	if event is int and event != 0:
		var localized_keycode = DisplayServer.keyboard_get_keycode_from_physical(event)
		pause_label.text = OS.get_keycode_string(localized_keycode)
	else:
		pause_label.text = "Unassigned"

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_menu"):
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

func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")

func _on_dificulty_pressed() -> void:
	dificulty_panel.visible = true
