class_name AttackCapability extends CardCapability

var _max_attack_range: int
var _damage: int

## _get_attacked_tiles should take the main tile as parameter and return Array[Vector2i]
func _init(max_attack_range: int, damage: int) -> void:
	_max_attack_range = max_attack_range
	_damage = damage

func get_valid_targets(caster: MapCharacter, map: HexMap) -> Array[Vector2i]:
	var targets: Array[Vector2i] = []
	for cell in map.get_cells_in_range(caster.get_tile(), _max_attack_range):
		var occupant: MapCharacter = map.get_character_at(cell) # check typing
		if occupant != null and caster.is_enemy_of(occupant):
			targets.append(cell)
	return targets

func build_effect(caster: MapCharacter, target_cell: Vector2i) -> CardEffect:
	var target := HexMap.instance().get_character_at(target_cell)
	return DamageEffect.new(target, _damage)
