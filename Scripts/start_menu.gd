extends Control

@onready var main_menu: Control = $MainMenu
@onready var option_panel: Panel = $OptionPanel
@onready var lanterne: Control = $OtherBackground/Lanterne
@onready var option_button: OptionButton = $OptionPanel/Options/ScrollContainer/CenterContainer/VBoxContainer/WindowOptions/MarginContainer/VBoxContainer/OptionButton

func _ready() -> void:
	main_menu.visible = true
	option_panel.visible = false
	lanterne.visible = true

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_options_pressed() -> void:
	main_menu.visible = false
	option_panel.visible = true
	lanterne.visible = false

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	_ready()

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
