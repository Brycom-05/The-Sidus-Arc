class_name Card extends RefCounted

var _id: int
var _capabilities: Array[CardCapability]

func _init(id: int, capabilities: Array[CardCapability]) -> void:
	_id = id
	_capabilities = capabilities

func get_id() -> int:
	return _id

func get_capabilities() -> Array[CardCapability]:
	return _capabilities
