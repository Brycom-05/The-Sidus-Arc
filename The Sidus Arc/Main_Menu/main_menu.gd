class_name MainMenu extends Node2D


signal start_game


@onready var start_button: TextureButton = %Start
@onready var settings_button: TextureButton = %Settings
@onready var quit_button: TextureButton = %Quit


const GAME_SCENE := preload("res://Map/level_manager.tscn")
const SETTINGS_SCENE := preload("res://Main_Menu/settings_menu.tscn")


func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	start_button.grab_focus()

	
func _on_start_pressed() -> void:
	start_game.emit()


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_packed(SETTINGS_SCENE)


func _on_quit_pressed() -> void:
	get_tree().quit()
