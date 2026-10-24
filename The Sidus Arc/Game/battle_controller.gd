class_name BattleController extends RefCounted

static var _instance: BattleController = BattleController.new()

static func instance() -> BattleController:
	if _instance == null:
		printerr("Singleton not created yet.")
	return _instance

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
	# TODO: Doesn't take into account UI, should eventually use queue and get signals from UI after animation
	
	# Movement first
	for character: MapCharacter in HexMap.instance().get_characters():
		var selected_card: Card = character.get_selected_card()
		if selected_card.get_type() != Card.CardType.MOVEMENT:
			continue
		
		CardController.instance().execute_card(character, selected_card)
	
	# Then rest
	for character: MapCharacter in HexMap.instance().get_characters():
		var selected_card: Card = character.get_selected_card()
		if selected_card.get_type() == Card.CardType.MOVEMENT:
			continue
		
		CardController.instance().execute_card(character, selected_card)
	

## The game checks for victory or defeat, discards played cards, 
## draws replacements when possible, updates the round counter, and generates the AI's next intent.
func cleanup_phase() -> void:
	# TODO
	pass
