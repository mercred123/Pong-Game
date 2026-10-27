extends Control

@onready var option_panel: Control = $OptionPanel
@onready var lanterne: Control = $OtherBackground/Lanterne

func _ready() -> void:
	option_panel.visible = false
	lanterne.visible = true

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_options_pressed() -> void:
	option_panel.visible = true
	lanterne.visible = false

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	_ready()
