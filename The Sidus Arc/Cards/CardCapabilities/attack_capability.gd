class_name AttackCapability extends CardCapability

var _max_attack_range: int
var _damage: int
var _get_attacked_tiles: Callable

## _get_attacked_tiles should take the main tile as parameter and return Array[Vector2i]
func _init(max_attack_range: int, damage: int, get_attacked_tiles: Callable) -> void:
	_max_attack_range = max_attack_range
	_damage = damage
	_get_attacked_tiles = get_attacked_tiles

func create_effect(source: Vector2i, destination: Vector2i) -> CardEffect:
	if source.distance_to(destination) > _max_attack_range:
		printerr("Illegal Move: Source and destination are two far apart: ", source.distance_to(destination), ". Supposed to be ", _max_attack_range)
		return null
	
	return AttackEffect.new(_get_attacked_tiles.call(destination), _damage)
