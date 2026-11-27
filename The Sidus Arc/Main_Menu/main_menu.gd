class_name MainMenu extends Node2D


signal start_game


@onready var start_button: TextureButton = %Start
@onready var settings_button: TextureButton = %Settings
@onready var quit_button: TextureButton = %Quit
@onready var background_music: AudioStreamPlayer = $BackgroundMusic
@onready var menu_layer: CanvasLayer = $Menu
@onready var foreground: Sprite2D = $Foreground


const GAME_SCENE := preload("res://Map/level_manager.tscn")
const SETTINGS_SCENE := preload("res://Main_Menu/settings_menu.tscn")

var _settings_menu: SettingsMenu = null


func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	if background_music.stream is AudioStreamMP3:
		(background_music.stream as AudioStreamMP3).loop = true
	background_music.play()

	start_button.grab_focus()

	
func _on_start_pressed() -> void:
	background_music.stop()
	start_game.emit()


func _on_settings_pressed() -> void:
	if _settings_menu != null:
		return
	menu_layer.visible = false
	foreground.visible = false
	_settings_menu = SETTINGS_SCENE.instantiate()
	_settings_menu.back_pressed.connect(_on_settings_back)
	add_child(_settings_menu)


func _on_settings_back() -> void:
	if _settings_menu != null:
		_settings_menu.queue_free()
		_settings_menu = null
	menu_layer.visible = true
	foreground.visible = true
	start_button.grab_focus()


func _on_quit_pressed() -> void:
	get_tree().quit()
