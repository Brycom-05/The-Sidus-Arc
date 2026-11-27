class_name MoveEffect extends CardEffect

const MOVE_DURATION := 0.25

var character: MapCharacter
var destination: Vector2i

func _init(p_character: MapCharacter, p_destination: Vector2i) -> void:
	character = p_character
	destination = p_destination

func get_affected_cells() -> Array[Vector2i]:
	return [destination]

# Update the new tile right away
# tweens the sprite from its old spot to the new one
func apply() -> void:
	# do not apply effect if character dies
	if not is_instance_valid(character) or character.is_dead:
		return
	
	var map := HexMap.instance()
	print("MoveEffect.apply: player -> ", destination)
	if not map.can_place_character(character, destination):
		print("MoveEffect.apply: destination rejected")
		return
	print("MoveEffect.apply: moving")
	var start_position := character.global_position
	map.move_character(character, destination)
	var end_position := character.global_position
	
	character.global_position = start_position
	var tween := character.create_tween()
	tween.tween_property(character, "global_position", end_position, MOVE_DURATION) \
	.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
