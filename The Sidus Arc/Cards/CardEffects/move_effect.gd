class_name MoveEffect extends CardEffect

var character: MapCharacter
var destination: Vector2i

func _init(p_character: MapCharacter, p_destination: Vector2i) -> void:
	character = p_character
	destination = p_destination

func get_affected_cells() -> Array[Vector2i]:
	return [destination]

func apply() -> void:
	HexMap.instance().move_character(character, destination)
