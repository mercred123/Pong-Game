extends Node

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

func _ready() -> void:
	if not FileAccess.file_exists(SETTINGS_FILE_PATH):
		_create_default_config()
	else:
		config.load(SETTINGS_FILE_PATH)

func _create_default_config() -> void:
	# Keybindings
	config.set_value("keybinding", "up", KEY_W)
	config.set_value("keybinding", "down", KEY_S)
	config.set_value("keybinding", "pause_menu", KEY_TAB)
	
	# Video
	config.set_value("video", "screen_mode", "WINDOWED")
	config.set_value("video", "screen_shake", true)
	
	# Audio
	config.set_value("audio", "master_volume", 1.0)
	config.set_value("audio", "sfx_volume", 0.1)
	config.set_value("audio", "music_volume", 0.02)
	
	config.save(SETTINGS_FILE_PATH)

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

func save_keybind(action: String, physical_keycode: Key) -> void:
	config.set_value("keybinding", action, physical_keycode)
	config.save(SETTINGS_FILE_PATH)

func load_keybinds() -> Dictionary:
	var keybinds = {}
	if config.has_section("keybinding"):
		for key in config.get_section_keys("keybinding"):
			keybinds[key] = config.get_value("keybinding", key)
	return keybinds
