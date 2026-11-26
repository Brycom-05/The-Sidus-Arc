class_name MoveCapability extends CardCapability

var _max_move_distance: int

func _init(max_move_distance: int) -> void:
	_max_move_distance = max_move_distance
	
# Check if valid targetr
func get_valid_targets(caster: MapCharacter, map: HexMap) -> Array[Vector2i]:
	var targets: Array[Vector2i] = []
	for cell in map.get_cells_in_range(caster.get_tile(), _max_move_distance):
		if map.can_place_character(caster, cell):
			targets.append(cell)
	return targets

# Build move effect
func create_effect(source: Vector2i, destination: Vector2i, character: MapCharacter) -> CardEffect:
	if source.distance_to(destination) > _max_move_distance:
		printerr("Illegal Move: Source and destination are two far apart: ", source.distance_to(destination), ". Supposed to be ", _max_move_distance)
		return null
	
	return MoveEffect.new(character, destination)
