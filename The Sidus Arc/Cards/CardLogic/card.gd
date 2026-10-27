class_name Card extends RefCounted

enum CardType {
	MOVEMENT,
}

var _id: int
var _type: CardType
var _capabilities: Array[CardCapability]

func _init(id: int, type: CardType, capabilities: Array[CardCapability]) -> void:
	_id = id
	_type = type
	_capabilities = capabilities

func get_id() -> int:
	return _id

func get_type() -> CardType:
	return _type

func get_capabilities() -> Array[CardCapability]:
	return _capabilities
