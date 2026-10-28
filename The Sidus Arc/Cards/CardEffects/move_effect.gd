class_name MoveEffect extends CardEffect

var _destination: Vector2i

func _init(destination: Vector2i) -> void:
	_destination = destination

func get_destination() -> Vector2i:
	return _destination
