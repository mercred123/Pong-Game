extends Node

var default_keybinds: Dictionary = {}

func _ready() -> void:
	_set_default_action_key("up", KEY_Z)
	_set_default_action_key("down", KEY_S)
	_set_default_action_key("pause_menu", KEY_TAB)
	
	for action in InputMap.get_actions():
		var events: Array[InputEventKey] = []
	
		for event in InputMap.action_get_events(action):
			if event is InputEventKey:
				events.append(event.duplicate())
	
		default_keybinds[action] = events

func _set_default_action_key(action: StringName, keycode: Key) -> void:
	for event in InputMap.action_get_events(action):
		InputMap.action_erase_event(action, event)
	
	var ev = InputEventKey.new()
	ev.keycode = keycode
	InputMap.action_add_event(action, ev)

func apply_keybind(action: StringName, event: InputEventKey) -> void:
	for old_event in InputMap.action_get_events(action):
		if old_event is InputEventKey:
			InputMap.action_erase_event(action, old_event)
	
	InputMap.action_add_event(action, event.duplicate())

func reset_keybind(action: StringName) -> void:
	if not default_keybinds.has(action):
		return
	
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			InputMap.action_erase_event(action, event)
	
	for event in default_keybinds[action]:
		InputMap.action_add_event(action, event.duplicate())

func is_default_keybind(action: StringName) -> bool:
	if not default_keybinds.has(action):
		return true
	
	var current: Array = InputMap.action_get_events(action)
	var defaults: Array = default_keybinds[action]
	
	if current.size() != defaults.size():
		return false
	
	for i in range(current.size()):
		var curr_ev = current[i]
		var def_ev = defaults[i]
		
		if curr_ev is InputEventKey and def_ev is InputEventKey:
			var curr_key = curr_ev.physical_keycode if curr_ev.physical_keycode != 0 else curr_ev.keycode
			var def_key = def_ev.physical_keycode if def_ev.physical_keycode != 0 else def_ev.keycode
			
			if curr_key != def_key:
				return false
		else:
			return false
			
	return true
