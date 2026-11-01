extends Control

signal actual_difficulty(difficulty: int)

@export var difficultyOption: OptionButton

func _ready() -> void:
	self.visible = false
	
	var difficulty_settings = ConfigFileHandler.load_difficulty_settings()
	var index = difficultyOption.get_item_index(difficulty_settings.mode)
	if index != -1:
		difficultyOption.select(index)
	
	actual_difficulty.emit(difficulty_settings.mode)

func _on_back_button_pressed() -> void:
	self.visible = false

func _on_option_button_item_selected(_index: int) -> void:
	var difficulty_id = difficultyOption.get_selected_id()
	actual_difficulty.emit(difficulty_id)
	ConfigFileHandler.save_difficulty_settings("mode", difficulty_id)
