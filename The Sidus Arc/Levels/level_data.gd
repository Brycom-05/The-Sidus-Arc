class_name LevelData extends Resource

@export var level_name: String
@export var player_start: Vector2i
@export var enemy_starts: Array[Vector2i]
@export var enemy_deck_ids: Array[int]
@export var enemy_texture: Texture2D
@export var tile_sources: Array[int] = [0]
@export var tile_coords: Array[Vector2i] = [Vector2i(0, 0)]
@export var before_cutscene: PackedScene
@export var after_cutscene: PackedScene
