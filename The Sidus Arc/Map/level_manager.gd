class_name LevelManager extends Node2D

func start_level(level: int) -> void:
	# TODO: Load level stuff here
	BattleController.instance().start_level()
