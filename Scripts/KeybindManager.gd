extends Node

const DEFAULT_KEYBINDS := {
	&"up": KEY_W,
	&"down": KEY_S,
	&"pause_menu": KEY_TAB
}

func _ready() -> void:
	var saved = ConfigFileHandler.load_keybinds()
	for action in DEFAULT_KEYBINDS.keys():
		var key = saved.get(action, DEFAULT_KEYBINDS[action])
		apply_keybind(action, key)

func apply_keybind(action: StringName, physical_keycode: Key) -> void:
	for event in InputMap.action_get_events(action):
		InputMap.action_erase_event(action, event)
	
	var event = InputEventKey.new()
	event.physical_keycode = physical_keycode
	InputMap.action_add_event(action, event)

func reset_keybind(action: StringName) -> void:
	if DEFAULT_KEYBINDS.has(action):
		var default_key = DEFAULT_KEYBINDS[action]
		apply_keybind(action, default_key)
		ConfigFileHandler.save_keybind(action, default_key)

func get_current_physical_keycode(action: StringName) -> Key:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			return event.physical_keycode
	return KEY_NONE

func is_default_keybind(action: StringName) -> bool:
	if not DEFAULT_KEYBINDS.has(action):
		return true
	return get_current_physical_keycode(action) == DEFAULT_KEYBINDS[action]

func get_action_using_physical_key(physical_key: Key, exclude_action: StringName) -> StringName:
	for action in DEFAULT_KEYBINDS.keys():
		if action == exclude_action:
			continue
		for event in InputMap.action_get_events(action):
			if event is InputEventKey and event.physical_keycode == physical_key:
				return action
	return &""
