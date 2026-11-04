class_name TurnManager extends RefCounted

var _current_turn: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_current_turn = 0
	
# Gets the turn game is on
func _get_turn() -> int:
	return _current_turn
	
# Increase turn count
func next_turn() -> void:
	_current_turn += 1
