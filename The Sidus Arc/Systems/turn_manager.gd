class_name TurnManager extends RefCounted

static var _instance: TurnManager = TurnManager.new()

var _current_turn: int = 0
var _player_turn: String = "Player"

static func instance() -> TurnManager:
	return _instance

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

# set which character's turn it is
func set_character_turn(who: String) -> void:
	_player_turn = who
	
## Increment turn count
func next_turn() -> void:
	_current_turn += 1
