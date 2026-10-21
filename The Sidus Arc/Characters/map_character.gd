class_name MapCharacter extends Sprite2D

static var NUMBER_OF_CHARACTERS: int = 0

var id: int

func _init() -> void:
	id = NUMBER_OF_CHARACTERS
	NUMBER_OF_CHARACTERS += 1
	scale = Vector2(0.5, 0.5)
	texture = preload("res://icon.svg")
	
