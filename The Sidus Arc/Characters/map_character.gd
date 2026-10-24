class_name MapCharacter extends Sprite2D

static var NUMBER_OF_CHARACTERS: int = 0

var id: int
var _card_effect: CardEffect = null
var _tile: Vector2i = Vector2i(0, 0)

func _init() -> void:
	id = NUMBER_OF_CHARACTERS
	NUMBER_OF_CHARACTERS += 1
	scale = Vector2(0.5, 0.5)
	texture = preload("res://icon.svg")

func move_character(dest: Vector2i) -> void:
	_tile = dest

func get_tile() -> Vector2i:
	return _tile

func get_card_effect() -> CardEffect:
	return _card_effect
