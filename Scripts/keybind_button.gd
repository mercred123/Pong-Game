extends Button

@export var action_name: StringName
@export var reset_action: TextureButton

var listening := false

func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
	
	pressed.connect(start_listening)
	focus_exited.connect(_on_focus_exited)
	
	if reset_action:
		reset_action.pressed.connect(_on_reset_pressed)
	
	var settings: Dictionary = ConfigFileHandler.load_keybind_settings()
	var saved: Variant = settings.get(str(action_name))
	
	if saved is InputEventKey:
		KeybindManager.apply_keybind(action_name, saved)
	
	update_text()

func start_listening() -> void:
	listening = true
	text = "Press..."

func _input(event: InputEvent) -> void:
	if not listening:
		return
	
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode in [KEY_SHIFT, KEY_CTRL, KEY_ALT, KEY_META]:
			return
	
		get_viewport().set_input_as_handled()
		rebind_key(event)

func rebind_key(event: InputEventKey) -> void:
	var new_event := event.duplicate() as InputEventKey
	new_event.pressed = false
	new_event.echo = false
	
	KeybindManager.apply_keybind(action_name, new_event)
	
	ConfigFileHandler.save_keybind_settings(
		action_name,
		new_event
	)
	
	listening = false
	update_text()

func _on_focus_exited() -> void:
	if listening:
		listening = false
		update_text()

func _on_reset_pressed() -> void:
	listening = false
	
	KeybindManager.reset_keybind(action_name)
	
	var default_events = InputMap.action_get_events(action_name)
	for event in default_events:
		if event is InputEventKey:
			ConfigFileHandler.save_keybind_settings(action_name, event)
			break
	
	update_text()

func update_text() -> void:
	var events := InputMap.action_get_events(action_name)
	
	for event in events:
		if event is InputEventKey:
			if event.physical_keycode != 0:
				var keycode := DisplayServer.keyboard_get_keycode_from_physical(
					event.physical_keycode
				)
				text = OS.get_keycode_string(keycode)
			elif event.keycode != 0:
				text = OS.get_keycode_string(event.keycode)
			else:
				text = "Unassigned"
	
			_update_reset_visibility()
			return
	
	text = "Unassigned"
	_update_reset_visibility()

func _update_reset_visibility() -> void:
	if reset_action:
		reset_action.visible = not KeybindManager.is_default_keybind(
			action_name
		)
