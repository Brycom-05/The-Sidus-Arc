class_name HexMap extends Node2D

@onready var base_layer = $BaseLayer

const DEFAULT_MAP_SIZE := Vector2i(12, 8)

static var _instance: HexMap = HexMap.new()

var map_characters: Array[MapCharacter] = []

static func instance() -> HexMap:
	if _instance == null:
		printerr("Singleton not created yet.")
	return _instance

func _ready() -> void:
	generate_map()

func generate_map() -> void:
	base_layer.clear()
	for x: int in range(0, DEFAULT_MAP_SIZE.x):
		for y: int in range(0, DEFAULT_MAP_SIZE.y):
			var cell := Vector2i(x, y)
			base_layer.set_cell(cell, 0, Vector2i(0, 0))
	
	# For testing
	
	var character1 := MapCharacter.new()
	var character2 := MapCharacter.new()
	
	add_character(character1)
	add_character(character2)
	
	place_character(character1, Vector2i(0, 0))
	place_character(character2, Vector2i(4, 5))


func add_character(character: MapCharacter) -> void:
	map_characters.push_back(character)
	character.visible = false
	add_child(character)

# Caller must queue_free
func remove_character(character: MapCharacter) -> void:
	var ind: int = map_characters.find(character)
	if ind != -1:
		map_characters.pop_at(ind)
	remove_child(character)

func place_character(character: MapCharacter, cell: Vector2i) -> void:
	character.position = base_layer.map_to_local(cell)
	character.visible = true
