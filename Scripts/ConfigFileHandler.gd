extends Node

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		#KeyBind
		var ev_up = InputEventKey.new()
		ev_up.keycode = KEY_Z
		config.set_value("keybinding", "up", ev_up)
	
		var ev_down = InputEventKey.new()
		ev_down.keycode = KEY_S
		config.set_value("keybinding", "down", ev_down)
	
		var ev_pause = InputEventKey.new()
		ev_pause.keycode = KEY_TAB
		config.set_value("keybinding", "pause_menu", ev_pause)
		
		#Video
		config.set_value("video", "screen_mode", "WINDOWED")
		config.set_value("video", "screen_shake", true)
		
		#Audio
		config.set_value("audio", "master_volume", 1.0)
		config.set_value("audio", "sfx_volume", 0.1)
		config.set_value("audio", "music_volume", 0.02)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)

func save_video_settings(key: String, value):
	config.set_value("video", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_video_settings():
	var video_settings = {}
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key)
	return video_settings

func save_audio_settings(key: String, value):
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_audio_settings():
	var audio_settings = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings

func save_keybind_settings(key: String, value):
	config.set_value("keybinding", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_keybind_settings():
	var keybind_settings = {}
	for key in config.get_section_keys("keybinding"):
		keybind_settings[key] = config.get_value("keybinding", key)
	return keybind_settings
