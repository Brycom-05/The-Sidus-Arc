class_name Card extends RefCounted

var _id: int
var _title: String
var _mana_cost: int
var _capabilities: Array[CardCapability]

func _init(id: int, title: String, mana_cost: int, capabilities: Array[CardCapability]) -> void:
	_id = id
	_title = title
	_mana_cost = mana_cost
	_capabilities = capabilities

func get_id() -> int:
	return _id
	
func get_title() -> String:
	return _title

func get_mana_cost() -> int:
	return _mana_cost

func get_capabilities() -> Array[CardCapability]:
	return _capabilities
