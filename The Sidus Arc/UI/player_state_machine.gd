class_name PlayerStateMachine extends RefCounted

static var _instance: PlayerStateMachine = PlayerStateMachine.new()

var _can_place_cards: bool = false

static func instance() -> PlayerStateMachine:
	if _instance == null:
		printerr("Singleton not created yet.")
	return _instance


func set_player_can_place_cards(can_place_cards: bool) -> void:
	_can_place_cards = can_place_cards

func get_player_can_place_cards() -> bool:
	return _can_place_cards
