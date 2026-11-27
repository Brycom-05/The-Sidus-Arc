extends Node2D

@onready var level_manager := $LevelManager
@onready var main_menu := $MainMenu

func _ready() -> void:
	BattleController.instantiate()
	
	main_menu.start_game.connect(_on_start_game)
	$UIController/MainCamera.center_on_map()
	
	
func _on_start_game() -> void:
	main_menu.queue_free()
	level_manager.start_level(0)
