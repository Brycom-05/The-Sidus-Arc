class_name MapCharacter extends Sprite2D

enum Team { PLAYER, ENEMY }

static var NUMBER_OF_CHARACTERS: int = 0

var id: int
var team: Team = Team.PLAYER
var max_hp: int = 10 # tentative
var hp: int = 10 # tentative
var _card_effects: Array[CardEffect] = []
var _tile: Vector2i = Vector2i(0, 0)
var mana_pool := ManaPool.new(0.0)

func _init() -> void:
	id = NUMBER_OF_CHARACTERS
	NUMBER_OF_CHARACTERS += 1
	hp = max_hp
	scale = Vector2(0.5, 0.5)
	texture = preload("res://icon.svg")
	
func take_damage(amount: int) -> void:
	hp = max(hp - amount, 0)
	print("Character ", id, " took ", amount, " damage, hp: ", hp)

func move_character(dest: Vector2i) -> void:
	_tile = dest

func get_tile() -> Vector2i:
	return _tile

func get_card_effects() -> Array[CardEffect]:
	return _card_effects

func next_turn() -> void:
	clear_card_effects()

func clear_card_effects() -> void:
	_card_effects.clear()

func queue_effect(effect: CardEffect) -> void:
	_card_effects.push_back(effect)

func is_enemy_of(other: MapCharacter) -> bool:
	return other != null and other.team != team
