class_name CardController extends RefCounted

static var _instance: CardController = CardController.new()

# Check if there is an instance for CardController, if not make one
static func instance() -> CardController:
	if _instance == null:
		printerr("Singleton not created yet.")
	return _instance

# Execute chard effect
# param [character]: which character is enacting the effect
# param [effect]: the effect on a character
func execute_card_effect(character: MapCharacter, effect: CardEffect) -> void:
	if effect is MoveEffect:
		HexMap.instance().move_character(character, effect.get_destination())
		
# Checks if a card can be played
# Check multiple conditions, else return true
func can_play_card(card: Card, character: MapCharacter, hand: Hand) -> bool:
	# ensure the card or character actually exist
	if card == null or character == null:
		return false
	
	# ensure the card is in the player's hand
	if not hand.hand.has(card):
		return false
		
	# Turn: compare against whoever is active
	if TurnManager.instance().get_character_turn() != "Player":
		return false
	
	# Mana: ask the character's pool
	if not character.mana_pool.can_play_card(card.get_mana_cost()):
		return false
		
	return true
