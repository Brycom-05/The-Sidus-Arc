extends Node2D

@onready var level_manager := $LevelManager
@onready var ui_controller := $UIController
@onready var main_menu := $MainMenu

func _ready() -> void:
	level_manager.hide()
	ui_controller.hide()
	
	BattleController.instantiate()
	
	main_menu.start_game.connect(_on_start_game)
	$UIController/MainCamera.center_on_map()
	
	
func _on_start_game() -> void:
	main_menu.queue_free()
	level_manager.start_level(0)
	ui_controller.show()
	level_manager.show()
