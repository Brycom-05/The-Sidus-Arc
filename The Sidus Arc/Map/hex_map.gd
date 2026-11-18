class_name HexMap extends Node2D

@onready var base_layer: TileMapLayer = $BaseLayer

const DEFAULT_MAP_SIZE := Vector2i(12, 8)

static var _instance: HexMap

var map_characters: Array[MapCharacter] = []
var timer: Timer

static func instance() -> HexMap:
	if _instance == null:
		printerr("Singleton not created yet.")
	return _instance

func _ready() -> void:
	_instance = self
	generate_map()

func generate_map() -> void:
	base_layer.clear()
	for x: int in range(0, DEFAULT_MAP_SIZE.x):
		for y: int in range(0, DEFAULT_MAP_SIZE.y):
			var cell := Vector2i(x, y)
			base_layer.set_cell(cell, 0, Vector2i(0, 0))
	
	# For testing
	#var deck := CardDatabase.create_deck_from_ids([2])
	#
	#var player := PlayerCharacter.new(deck)
	#var enemy := EnemyCharacter.new(deck)
	#
	#add_character(player)
	#add_character(enemy)
	#
	#place_character(player, Vector2i(0, 0))
	#place_character(enemy, Vector2i(4, 5))
	#
	#timer = Timer.new()
	#timer.one_shot = true
	#timer.timeout.connect(test_env)
	#add_child(timer)
	#timer.start(2)
	

func test_env() -> void:
	BattleController.instance().reveal_phase()
	BattleController.instance().resolution_phase()

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
	character.move_character(cell)
	character.visible = true

func move_character(character: MapCharacter, cell: Vector2i) -> void:
	print("Moving from ", character.get_tile(), " to ", cell)
	character.position = base_layer.map_to_local(cell)
	character.move_character(cell)

func get_characters() -> Array[MapCharacter]:
	return map_characters

## TODO
func reveal_enemy_moves() -> void:
	pass

## Returns the map's tile bounds in global coordinates.
func get_map_bounds() -> Rect2:
	var cells := base_layer.get_used_cells()
	if cells.is_empty():
		return Rect2(base_layer.global_position, Vector2.ZERO)
	var tile_size := Vector2(base_layer.tile_set.tile_size)
	var bounds := Rect2(base_layer.map_to_local(cells[0]) - tile_size / 2.0, tile_size)
	for cell: Vector2i in cells:
		var tile_bounds := Rect2(base_layer.map_to_local(cell) - tile_size / 2.0, tile_size)
		bounds = bounds.merge(tile_bounds)
	return base_layer.global_transform * bounds
