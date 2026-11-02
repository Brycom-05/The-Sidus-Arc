class_name BattleController extends RefCounted

static var _instance: BattleController = BattleController.new()

var resolution_card_effects: Array[CharacterEffectTuple] = []

class CharacterEffectTuple:
	var character: MapCharacter
	var effect: CardEffect
	
	
	func _init(p_character: MapCharacter, p_effect: CardEffect) -> void:
		character = p_character
		effect = p_effect

static func instance() -> BattleController:
	if _instance == null:
		printerr("Singleton not created yet.")
	return _instance

func _init() -> void:
	UIController.instance().player_ends_plan_phase.connect(plan_phase_end)

##  The AI's committed card, destination, and any target tile are shown to the player.
func reveal_phase() -> void:
	# TODO: Potentially priority system for AI's if they depend on one another
	for character: MapCharacter in HexMap.instance().get_characters():
		if character is not EnemyCharacter:
			continue
		
		var enemy_character: EnemyCharacter = character
		enemy_character.pick_move()
		
		HexMap.instance().reveal_enemy_moves()

## The player chooses a movement destination or one card from their hand. 
## Cards that need a target require the player to select a tile. 
## The player confirms the action before resolution begins.
func plan_phase_start() -> void:
	PlayerStateMachine.instance().set_player_can_place_cards(true)

func plan_phase_end() -> void:
	# TODO: Take in moves here
	
	PlayerStateMachine.instance().set_player_can_place_cards(false)

## Both mages attempt their committed movements. Card effects scheduled to impact 
## that round are resolved using the resulting positions. Damage is calculated and applied simultaneously.
func resolution_phase() -> void:
	resolution_card_effects.clear()
	UIController.instance().card_effect_animation_ended.connect(play_next_card_effect)

	# Movement first
	for character: MapCharacter in HexMap.instance().get_characters():
		var card_effects: Array[CardEffect] = character.get_card_effects()
		for effect: CardEffect in card_effects:
			if effect is MoveEffect:
				continue
			resolution_card_effects.push_back(CharacterEffectTuple.new(
				character, effect
			))
	
	# Then rest
	for character: MapCharacter in HexMap.instance().get_characters():
		var card_effects: Array[CardEffect] = character.get_card_effects()
		for effect: CardEffect in card_effects:
			if effect is not MoveEffect:
				continue
			resolution_card_effects.push_back(CharacterEffectTuple.new(
				character, effect
			))

func play_next_card_effect() -> void:
	if not resolution_card_effects.is_empty():
		var next_effect: CharacterEffectTuple = resolution_card_effects.pop_front()
		CardController.instance().execute_card_effect(next_effect.character, next_effect.effect)
		UIController.instance().play_effect(next_effect.effect)
	else:
		# Resolution phase done
		cleanup_phase()

## The game checks for victory or defeat, discards played cards, 
## draws replacements when possible, updates the round counter, and generates the AI's next intent.
func cleanup_phase() -> void:
	# TODO
	pass
