class_name AttackCapability extends CardCapability

var max_attack_range: int
var damage: int
var area_radius: int

## _get_attacked_tiles should take the main tile as parameter and return Array[Vector2i]
func _init(p_max_attack_range: int, card_damage: int, p_area_radius: int = 0) -> void:
	max_attack_range = p_max_attack_range
	damage = card_damage
	area_radius = p_area_radius

func get_area_radius() -> int:
	return area_radius

func get_valid_targets(caster: MapCharacter, map: HexMap) -> Array[Vector2i]:
	var targets: Array[Vector2i] = []
	for cell in map.get_cells_in_range(caster.get_tile(), max_attack_range):
		var occupant: MapCharacter = map.get_character_at(cell) # check typing
		if occupant != null and caster.is_enemy_of(occupant):
			targets.append(cell)
	return targets

func build_effect(caster: MapCharacter, target_cell: Vector2i) -> CardEffect:
	var map := HexMap.instance()
	var cells: Array[Vector2i] = []
	# exclude mountains from targeted cells
	for cell in map.get_footprint(target_cell, area_radius):
		if not map.mountain_cells.has(cell):
			cells.append(cell)
	return DamageEffect.new(caster, cells, damage)
