class_name LevelManager extends Node2D

const STAGE_ONE_CARD_IDS: Array[int] = [1, 2, 3, 4, 5]
const STARTING_MANA := 100.0

@onready var hex_map: HexMap = $HexMap
@onready var background_music: AudioStreamPlayer = $BackgroundMusic

var player: PlayerCharacter

func start_level(level: int) -> void:
	# TODO: Load level stuff here
	background_music.play()
	if is_instance_valid(player):
		hex_map.remove_character(player)
		player.queue_free()

	var deck := CardDatabase.create_deck_from_ids(STAGE_ONE_CARD_IDS)
	player = PlayerCharacter.new(deck)
	player.mana_pool = ManaPool.new(STARTING_MANA)
	player.next_turn()
	hex_map.add_character(player)
	UIController.instance().show_player_hand(player)

	BattleController.instance().start_level()
