class_name Card extends RefCounted

enum CardType {
	MOVEMENT,
}

var _id: int
var _type: CardType
var _capability: CardCapability

func _init(id: int, type: CardType, capability: CardCapability) -> void:
	_id = id
	_type = type
	_capability = capability

func get_id() -> int:
	return _id

func get_type() -> CardType:
	return _type

func get_capability() -> CardCapability:
	return _capability
