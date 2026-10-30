extends Button

@export var action_name: StringName
@export var reset_action: TextureButton

signal conflict_detected(key_string: String, conflicting_action: StringName)

var listening := false

func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
	pressed.connect(start_listening)
	focus_exited.connect(func(): if listening: cancel_listening())
	
	if reset_action:
		reset_action.pressed.connect(_on_reset_pressed)
	
	update_display()

func start_listening() -> void:
	listening = true
	text = "Press..."

func cancel_listening() -> void:
	listening = false
	update_display()

func _input(event: InputEvent) -> void:
	if not listening:
		return
	
	if event is InputEventKey and event.pressed and not event.echo:
		if event.physical_keycode in [KEY_SHIFT, KEY_CTRL, KEY_ALT, KEY_META]:
			return
		
		get_viewport().set_input_as_handled()
		rebind(event.physical_keycode)

func rebind(physical_keycode: Key) -> void:
	var conflicting_action = KeybindManager.get_action_using_physical_key(physical_keycode, action_name)
	
	if conflicting_action != &"":
		var localized_keycode = DisplayServer.keyboard_get_keycode_from_physical(physical_keycode)
		var key_string = OS.get_keycode_string(localized_keycode)
		
		conflict_detected.emit(key_string, conflicting_action)
		
		if owner and owner.has_method("_on_keybind_conflict"):
			owner._on_keybind_conflict(key_string, conflicting_action)
			
		listening = false
		update_display()
		return

	KeybindManager.apply_keybind(action_name, physical_keycode)
	ConfigFileHandler.save_keybind(action_name, physical_keycode)
	
	listening = false
	update_display()

func _on_reset_pressed() -> void:
	listening = false
	KeybindManager.reset_keybind(action_name)
	update_display()

func update_display() -> void:
	var physical_key = KeybindManager.get_current_physical_keycode(action_name)
	if physical_key != KEY_NONE:
		var localized_keycode = DisplayServer.keyboard_get_keycode_from_physical(physical_key)
		text = OS.get_keycode_string(localized_keycode)
	else:
		text = "Unassigned"
	
	if reset_action:
		reset_action.visible = not KeybindManager.is_default_keybind(action_name)
