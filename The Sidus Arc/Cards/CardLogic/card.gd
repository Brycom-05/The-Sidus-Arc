class_name Card extends RefCounted

enum CardType {
	MOVEMENT,
}

var _id: int
var _type: CardType

func _init(id: int, _type: CardType) -> void:
	_id = id

func get_id() -> int:
	return _id

func get_type() -> CardType:
	return _type
