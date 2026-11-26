class_name HexMap extends Node2D

@onready var base_layer: TileMapLayer = $BaseLayer
@onready var highlight_layer: TileMapLayer = $HighlightLayer
@onready var enemy_telegraph_layer: TileMapLayer = $EnemyTelegraphs

const DEFAULT_MAP_SIZE := Vector2i(12, 8)
const PLAYER_START_CELL := Vector2i(0, DEFAULT_MAP_SIZE.y - 1)
const MOUNTAIN_COUNT := 10
const MOUNTAIN_TEXTURE: Texture2D = preload("res://Map/Map_Assets/StageOne/mountain_tile.png")
const MOUNTAIN_SHADER: Shader = preload("res://Map/mountain_tile.gdshader")
# Crop the supplied image's padding and fit its grass surface to a 64 x 32 hex.
const MOUNTAIN_REGION := Rect2(273, 350, 708, 512)
const MOUNTAIN_SURFACE_SIZE := Vector2(708, 384)
const MOUNTAIN_SURFACE_CENTER := Vector2(354, 218)
const TILE_OUTLINE_COLOR := Color("24552c")
const TILE_OUTLINE_SCREEN_WIDTH := 1.25

static var _instance: HexMap

var map_characters: Array[MapCharacter] = []
var timer: Timer
var _tile_outlines: Node2D
var _outline_segments := PackedVector2Array()
var _outline_canvas_scale := 0.0
var mountain_cells: Dictionary[Vector2i, bool] = {}
var _mountains: Node2D

static func instance() -> HexMap:
	if _instance == null:
		printerr("Singleton not created yet.")
	return _instance

func _ready() -> void:
	_instance = self
	# Draw after the tile layers, before characters added by the level manager.
	_tile_outlines = Node2D.new()
	_tile_outlines.name = "TileOutlines"
	add_child(_tile_outlines)
	_tile_outlines.draw.connect(_draw_tile_outlines)
	_mountains = Node2D.new()
	_mountains.name = "Mountains"
	_mountains.y_sort_enabled = true
	add_child(_mountains)
	move_child(_mountains, _tile_outlines.get_index())
	generate_map()

func _process(_delta: float) -> void:
	var canvas_scale := _tile_outlines.get_global_transform_with_canvas().x.length()
	if not is_equal_approx(canvas_scale, _outline_canvas_scale):
		_outline_canvas_scale = canvas_scale
		_tile_outlines.queue_redraw()

func _draw_tile_outlines() -> void:
	# Compensate for camera zoom and map scale so borders cannot shrink away.
	var canvas_scale := _tile_outlines.get_global_transform_with_canvas().x.length()
	if canvas_scale > 0.0 and not _outline_segments.is_empty():
		_tile_outlines.draw_multiline(_outline_segments, TILE_OUTLINE_COLOR,
			TILE_OUTLINE_SCREEN_WIDTH / canvas_scale, true)

func _rebuild_tile_outlines() -> void:
	_outline_segments.clear()
	var half_size := Vector2(base_layer.tile_set.tile_size) / 2.0
	# Flat-topped hexes used by this board's TileSet.
	var corners := PackedVector2Array([
		Vector2(-half_size.x, 0), Vector2(-half_size.x / 2.0, -half_size.y),
		Vector2(half_size.x / 2.0, -half_size.y), Vector2(half_size.x, 0),
		Vector2(half_size.x / 2.0, half_size.y), Vector2(-half_size.x / 2.0, half_size.y),
	])
	var edges := {}
	for cell: Vector2i in base_layer.get_used_cells():
		var center := base_layer.map_to_local(cell)
		for i: int in range(corners.size()):
			var a := base_layer.transform * (center + corners[i])
			var b := base_layer.transform * (center + corners[(i + 1) % corners.size()])
			if a.x > b.x or (a.x == b.x and a.y > b.y):
				var swap := a
				a = b
				b = swap
			var key := Vector4(a.x, a.y, b.x, b.y)
			if not edges.has(key):
				edges[key] = true
				_outline_segments.append(a)
				_outline_segments.append(b)
	_tile_outlines.queue_redraw()

func generate_map(source_id: Array[int] = [0], ground_tiles: Array[Vector2i] = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0)], reserved_cells: Array[Vector2i] = []) -> void:
	base_layer.clear()
	for x: int in range(0, DEFAULT_MAP_SIZE.x):
		for y: int in range(0, DEFAULT_MAP_SIZE.y):
			var cell := Vector2i(x, y)
			base_layer.set_cell(cell, source_id.pick_random(), ground_tiles.pick_random())
	_rebuild_tile_outlines()
	_generate_mountains(reserved_cells)

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
	

func _generate_mountains(reserved_cells: Array[Vector2i] = []) -> void:
	if reserved_cells.is_empty():
		reserved_cells = [PLAYER_START_CELL]
	mountain_cells.clear()
	for child: Node in _mountains.get_children():
		_mountains.remove_child(child)
		child.queue_free()
	var candidates: Array[Vector2i] = []
	for cell: Vector2i in base_layer.get_used_cells():
		if not reserved_cells.has(cell) and can_place_character(null, cell):
			candidates.append(cell)
	candidates.shuffle()
	var mountain_material := ShaderMaterial.new()
	mountain_material.shader = MOUNTAIN_SHADER
	for i: int in range(mini(MOUNTAIN_COUNT, candidates.size())):
		var cell := candidates[i]
		mountain_cells[cell] = true
		var mountain := Sprite2D.new()
		mountain.name = "Mountain_%s_%s" % [cell.x, cell.y]
		mountain.texture = MOUNTAIN_TEXTURE
		mountain.region_enabled = true
		mountain.region_rect = MOUNTAIN_REGION
		mountain.centered = false
		mountain.offset = -MOUNTAIN_SURFACE_CENTER
		mountain.scale = Vector2(base_layer.tile_set.tile_size) / MOUNTAIN_SURFACE_SIZE
		mountain.position = base_layer.map_to_local(cell)
		mountain.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		mountain.material = mountain_material
		_mountains.add_child(mountain)
	_mountains.transform = base_layer.transform

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
	if not can_place_character(character, cell):
		return
	character.global_position = base_layer.to_global(base_layer.map_to_local(cell))
	character.move_character(cell)
	character.visible = true

func move_character(character: MapCharacter, cell: Vector2i) -> void:
	if not can_place_character(character, cell):
		return
	print("Moving from ", character.get_tile(), " to ", cell)
	character.global_position = base_layer.to_global(base_layer.map_to_local(cell))
	character.move_character(cell)

func can_place_character(character: MapCharacter, cell: Vector2i) -> bool:
	if base_layer.get_cell_source_id(cell) == -1 or mountain_cells.has(cell):
		return false
	for other: MapCharacter in map_characters:
		if other != character and other.get_tile() == cell:
			return false
	return true

func get_characters() -> Array[MapCharacter]:
	return map_characters

func reveal_enemy_moves() -> void: # get card effects from character instead of parameter
	enemy_telegraph_layer.clear()
	for character: MapCharacter in map_characters:
		if character is not EnemyCharacter:
			continue
		for effect: CardEffect in character.get_card_effects():
			for cell: Vector2i in effect.get_affected_cells():
				enemy_telegraph_layer.set_cell(cell, 0, Vector2i(0,0))

func clear_enemy_moves() -> void:
	enemy_telegraph_layer.clear()

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

# Added
# Gets the cells in range for attack/movement capabilities
func get_cells_in_range(origin: Vector2i, max_range: int) -> Array[Vector2i]:
	var visited: Dictionary = {origin: true}
	var frontier: Array[Vector2i] = [origin]
	var result: Array[Vector2i] = []
	
	for step in range(max_range):
		var next: Array[Vector2i] = []
		for cell in frontier:
			# checl all tiles surrounding the caster
			for neighbor in base_layer.get_surrounding_cells(cell):
				if visited.has(neighbor): # if already visited, skip
					continue
				if base_layer.get_cell_source_id(neighbor) == -1: # if tile is on the map, skip
					continue
				if mountain_cells.has(neighbor): # if cell is a mountain
					continue
				visited[neighbor] = true
				next.append(neighbor)
				result.append(neighbor)
		frontier = next
	
	return result

# get the character standing on a cell
func get_character_at(cell: Vector2i) -> MapCharacter:
		for character in map_characters:
			if character.get_tile() == cell:
				return character
		return null
	
# map cell under the mouse cursor
func cell_under_mouse() -> Vector2i:
	return base_layer.local_to_map(base_layer.get_local_mouse_position())
