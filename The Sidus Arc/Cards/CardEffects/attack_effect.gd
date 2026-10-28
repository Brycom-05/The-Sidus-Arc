class_name AttackEffect extends CardEffect

var _targetted_tiles: Array[Vector2i]
var _damage: int

func _init(targetted_tiles: Array[Vector2i], damage: int) -> void:
	_targetted_tiles = targetted_tiles
	_damage = damage

func get_targetted_tiles() -> Array[Vector2i]:
	return _targetted_tiles

func get_damage() -> int:
	return _damage
