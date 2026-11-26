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

# targetting with capability
func get_primary_capability() -> CardCapability:
	if (not _capabilities[0].is_empty()):
		return _capabilities[0]
	else:
		return null
		
# tiles the card can be played on from the caster's position
func get_valid_targets(caster: MapCharacter, map: HexMap) -> Array[Vector2i]:
	var cap := get_primary_capability()
	return cap.get_valid_targets(caster, map) if cap else []

# effect when player picks target cell
func build_effect(caster: MapCharacter, target_cell: Vector2i) -> CardEffect:
	var cap := get_primary_capability()
	return cap.build_effect(caster, target_cell) if cap else null
