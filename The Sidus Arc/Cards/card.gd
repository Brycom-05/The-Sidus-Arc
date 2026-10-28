class_name Card extends RefCounted

var _id: int
# test commit

func _init(id: int) -> void:
	_id = id

func get_id() -> int:
	return _id
