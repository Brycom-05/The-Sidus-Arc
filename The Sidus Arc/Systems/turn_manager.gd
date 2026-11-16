class_name TurnManager extends RefCounted

var _current_turn: int
var _player_turn: String

func _init() -> void:
	reset()

func reset() -> void:
	_current_turn = 0
	
## Gets the turn game is on
func get_turn() -> int:
	return _current_turn

## Gets whose turn it is
## may switch this to a bool
func get_character_turn() -> String:
	return _player_turn
	
## Increment turn count
func next_turn() -> void:
	_current_turn += 1
