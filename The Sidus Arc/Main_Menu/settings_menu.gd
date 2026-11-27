class_name SettingsMenu extends Node2D


const MAIN_MENU_SCENE := "res://Game/root.tscn"


@onready var back_button: TextureButton = %Back
@onready var fullscreen_button: CheckBox = %FullsreenCheck
@onready var volume_slider: HSlider = %AudioSlider
@onready var volume_progress: TextureProgressBar = %AudioProgress


func _ready() -> void:
	
	back_button.pressed.connect(_on_back_pressed)
	
	fullscreen_button.button_pressed = (
		DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	)

	fullscreen_button.toggled.connect(_on_fullscreen_toggled)

	
	volume_slider.min_value = 0
	volume_slider.max_value = 100
	volume_slider.value = 100
	
	volume_progress.value = volume_slider.value

	volume_slider.value_changed.connect(_on_volume_changed)
	
	
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)


func _on_fullscreen_toggled(enabled: bool) -> void:
	if enabled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_volume_changed(value: float) -> void:
	volume_progress.value = value
	
	var bus_index = AudioServer.get_bus_index("Master")

	# Convert percentage to decibels
	if value <= 0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(
			bus_index,
			linear_to_db(value / 100.0)
		)
		
