class_name TurnManager extends RefCounted

var _current_turn: int
var _player_turn: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_current_turn = 0
	
# Gets the turn game is on
func get_turn() -> int:
	return _current_turn

# Gets whose turn it is
# may switch this to a bool
func get_character_turn() -> String:
	return _player_turn
	
# Increase turn count
func next_turn() -> void:
	_current_turn += 1
