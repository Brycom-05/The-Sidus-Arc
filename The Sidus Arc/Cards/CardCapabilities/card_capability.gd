class_name CardCapability extends RefCounted

# Tiles the card capability can be used on, given the character
func get_valid_targets(_caster: MapCharacter, _map: HexMap) -> Array[Vector2i]:
	return []

# The effect that happens when the player picks the target cell
func build_effect(_caster: MapCharacter, _target_cell: Vector2i) -> CardEffect:
	return null

# Radius of the area around the target
# 0 means a single tile
func get_area_radius() -> int:
	return 0
