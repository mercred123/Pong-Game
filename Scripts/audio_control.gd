extends HSlider

@export var audio_bus_name: String
@export var volume_offset_db: float = 0.0
@export var value_label: Label

var audio_bus_id

func _ready() -> void:
	audio_bus_id = AudioServer.get_bus_index(audio_bus_name)
	
	if audio_bus_id == -1:
		push_error("Bus introuvable : " + audio_bus_name)
		return
	
	value_changed.connect(_on_value_changed)
	_on_value_changed(value)

func _on_value_changed(new_value: float) -> void:
	if audio_bus_id == -1:
		return
	
	if value_label:
		value_label.text = str(roundi(new_value * 100)) + "%"
	
	var db = linear_to_db(new_value) + volume_offset_db
	AudioServer.set_bus_volume_db(audio_bus_id, db)
