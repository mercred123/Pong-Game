extends Control

signal show_fps

@export_category("References")
@export var audio_master_control: HSlider
@export var audio_sfx_control: HSlider
@export var audio_music_control: HSlider
@export var option_screen_button: OptionButton
@export var shake_screen_check_box: CheckBox
@export var keybind_popup: CenterContainer
@export var vsync_check_box: CheckBox
@export var fps_check_box: CheckBox

func _ready() -> void:
	keybind_popup.visible = false
	
	var video_settings = ConfigFileHandler.load_video_settings()
	match video_settings.get("screen_mode", "WINDOWED"):
		"WINDOWED":
			option_screen_button.selected = 0
			ConfigFileHandler.save_video_settings("screen_mode", "WINDOWED")
		"MAXIMIZED":
			option_screen_button.selected = 1
			ConfigFileHandler.save_video_settings("screen_mode", "MAXIMIZED")
		"FULLSCREEN":
			option_screen_button.selected = 2
			ConfigFileHandler.save_video_settings("screen_mode", "FULLSCREEN")
	
	shake_screen_check_box.button_pressed = video_settings.get("screen_shake", true)
	fps_check_box.button_pressed = video_settings.get("show_fps", false)
	vsync_check_box.button_pressed = video_settings.get("vsync", false)
	
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
	keybind_popup.visible = false

func _on_keybind_conflict(key_string: StringName, conflicting_action: StringName):
	keybind_popup.visible = true
	$OptionPanel/KeybindPopup/AnimationPlayer.play("error_keybind")
	$OptionPanel/KeybindPopup/Panel/MarginContainer/VBoxContainer/Label.text = "Key Conflict: '%s' is already assigned to '%s'." % [key_string, conflicting_action]

func _on_vsync_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		ConfigFileHandler.save_video_settings("vsync", true)
	elif toggled_on == false:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		ConfigFileHandler.save_video_settings("vsync", false)

func _on_fps_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		show_fps.emit()
		ConfigFileHandler.save_video_settings("show_fps", true)
	elif toggled_on == false:
		show_fps.emit()
		ConfigFileHandler.save_video_settings("show_fps", false)
