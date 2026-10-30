extends Control

@onready var audio_master_control: HSlider = $OptionPanel/Options/ScrollContainer/CenterContainer/VBoxContainer/AudioOptions/MarginContainer/VBoxContainer/MASTER/AudioMasterControl
@onready var audio_sfx_control: HSlider = $OptionPanel/Options/ScrollContainer/CenterContainer/VBoxContainer/AudioOptions/MarginContainer/VBoxContainer/SFX/AudioSFXControl
@onready var audio_music_control: HSlider = $OptionPanel/Options/ScrollContainer/CenterContainer/VBoxContainer/AudioOptions/MarginContainer/VBoxContainer/MUSIC/AudioMusicControl
@onready var option_button: OptionButton = $OptionPanel/Options/ScrollContainer/CenterContainer/VBoxContainer/VideoOptions/MarginContainer/VBoxContainer/HBoxContainer/ScreenModeButton
@onready var shake_screen_check_box: CheckBox = $OptionPanel/Options/ScrollContainer/CenterContainer/VBoxContainer/VideoOptions/MarginContainer/VBoxContainer/ShakeScreenCheckBox
@onready var keybind_issue: CenterContainer = $OptionPanel/KeybindIssue

func _ready() -> void:
	keybind_issue.visible = false
	
	var video_settings = ConfigFileHandler.load_video_settings()
	match video_settings.screen_mode:
		"WINDOWED":
			option_button.selected = 0
		"MAXIMIZED":
			option_button.selected = 1
		"FULLSCREEN":
			option_button.selected = 2
	
	shake_screen_check_box.button_pressed = video_settings.screen_shake
	
	var audio_settings = ConfigFileHandler.load_audio_settings()
	audio_master_control.value = audio_settings.master_volume
	audio_sfx_control.value = audio_settings.sfx_volume
	audio_music_control.value = audio_settings.music_volume

func _on_back_button_pressed() -> void:
	self.visible = false

func _on_screen_mode_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			ConfigFileHandler.save_video_settings("screen_mode", "WINDOWED")
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			ConfigFileHandler.save_video_settings("screen_mode", "MAXIMIZED")
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			ConfigFileHandler.save_video_settings("screen_mode", "FULLSCREEN")

func _on_shake_screen_check_box_toggled(toggled_on: bool) -> void:
	ConfigFileHandler.save_video_settings("screen_shake", toggled_on)

func _on_audio_master_control_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_settings("master_volume", audio_master_control.value)

func _on_audio_sfx_control_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_settings("sfx_volume", audio_sfx_control.value)

func _on_audio_music_control_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_settings("music_volume", audio_music_control.value)

func _on_back_to_options_button_pressed() -> void:
	keybind_issue.visible = false

func _on_keybind_conflict(key_string: StringName, conflicting_action: StringName):
	keybind_issue.visible = true
	$OptionPanel/KeybindIssue/AnimationPlayer.play("error_keybind")
	$OptionPanel/KeybindIssue/Panel/MarginContainer/VBoxContainer/Label.text = "Key Conflict: '%s' is already assigned to '%s'." % [key_string, conflicting_action]
