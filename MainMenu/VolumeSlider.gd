extends HSlider


@export var bus_name: String
@export var sound_audio_stream: AudioStream

var bus_index: int


func _ready() -> void:
	# Get bus index by name
	bus_index = AudioServer.get_bus_index(bus_name)

	# Connect value changed signal
	value_changed.connect(_on_value_changed)

	# Connect drag ended signal if sound is provided
	if sound_audio_stream:
		drag_ended.connect(_on_drag_ended)

	# Initialise slider with current bus volume
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))


func _on_value_changed(new_value: float) -> void:
	# Set new bus volume using linear_to_db
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(new_value)
	)


func _on_drag_ended(_value_changed: bool) -> void:
	# Play sound when drag ended
	GameManager.play_audio_stream(sound_audio_stream)