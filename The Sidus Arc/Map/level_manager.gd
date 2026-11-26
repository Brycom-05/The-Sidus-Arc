class_name LevelManager extends Node2D

const STAGE_ONE_CARD_IDS: Array[int] = [1, 2, 3, 4, 5]
const STARTING_MANA := 100.0

signal level_completed

@onready var targeting: TargetingController = $TargetingController

@export var levels: Array[LevelData]
@export var intro_cutscene: PackedScene

@onready var hex_map: HexMap = $HexMap
@onready var background_music: AudioStreamPlayer = $BackgroundMusic

var cutscene_layer := CanvasLayer.new()
var player: PlayerCharacter
var hand: Hand # Added: Hand

func _ready() -> void:
	cutscene_layer.layer = 100
	add_child(cutscene_layer)

func play_cutscene(scene: PackedScene, keep_open: bool = false) -> Cutscene:
	if scene == null:
		return null
	var cutscene: Cutscene = scene.instantiate()
	cutscene_layer.add_child(cutscene)
	await cutscene.finished
	if keep_open:
		return cutscene
	cutscene.queue_free()
	return null

func _ready() -> void:
	cutscene_layer.layer = 100
	add_child(cutscene_layer)

func play_cutscene(scene: PackedScene, keep_open: bool = false) -> Cutscene:
	if scene == null:
		return null
	var cutscene: Cutscene = scene.instantiate()
	cutscene_layer.add_child(cutscene)
	await cutscene.finished
	if keep_open:
		return cutscene
	cutscene.queue_free()
	return null

func start_level(level: int) -> void:
	background_music.play()
	if is_instance_valid(player):
		hex_map.remove_character(player)
		player.queue_free()

	for i: int in range(level, levels.size()):
		await _run_level(i)	

func _run_level(i: int) -> void:
	var data: LevelData = levels[i]
		
	if i == 0:
		var intro: Cutscene = await play_cutscene(intro_cutscene, true)
		if intro != null:
			await intro.fade_to_black()
			_generate_level_map(data)
			await intro.fade_from_black()
			intro.queue_free()
	await play_cutscene(data.before_cutscene)

	load_level(i)
	await level_completed
	clear_level()

	var after: Cutscene = await play_cutscene(data.after_cutscene, true)

	if (after != null) and (i + 1 < levels.size()):
		await after.fade_to_black()
		_generate_level_map(levels[i + 1])
		await after.fade_from_black()

	if after != null:
		after.queue_free()	


func _generate_level_map(data: LevelData) -> void:
	var reserved: Array[Vector2i] = [data.player_start]
	reserved.append_array(data.enemy_starts)
	hex_map.generate_map(data.tile_sources, data.tile_coords, reserved)


func clear_level() -> void:
	for character: MapCharacter in hex_map.get_characters().duplicate():
		hex_map.remove_character(character)
		character.queue_free()


func load_level(index: int) -> void:
	var data: LevelData = levels[index]

	var deck := CardDatabase.create_deck_from_ids(STAGE_ONE_CARD_IDS)
	player = PlayerCharacter.new(deck)
	player.mana_pool = ManaPool.new(STARTING_MANA)
	hex_map.add_character(player)
	hex_map.place_character(player, data.player_start)
	
	player.hand.draw_starting_hand() # Added: player draws starting hand at the start of level

	for cell: Vector2i in data.enemy_starts:
		var enemy := EnemyCharacter.new(CardDatabase.create_deck_from_ids(data.enemy_deck_ids))
		hex_map.add_character(enemy)
		hex_map.place_character(enemy, cell)
	
	BattleController.instance().start_level()

# for testing battle ending
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_N:
		level_completed.emit()
