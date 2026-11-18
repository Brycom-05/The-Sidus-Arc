extends Node2D

@onready var level_manager := $LevelManager

func _ready() -> void:
	BattleController.instantiate()
	
	level_manager.start_level(0) # For testing
	$UIController/MainCamera.center_on_map()
