class_name MoveCapability extends CardCapability

var _max_move_distance: int

func _init(max_move_distance: int) -> void:
	_max_move_distance = max_move_distance

func create_effect(source: Vector2i, destination: Vector2i) -> CardEffect:
	if source.distance_to(destination) > _max_move_distance:
		printerr("Illegal Move: Source and destination are two far apart: ", source.distance_to(destination), ". Supposed to be ", _max_move_distance)
		return null
	
	return MoveEffect.new(destination)
