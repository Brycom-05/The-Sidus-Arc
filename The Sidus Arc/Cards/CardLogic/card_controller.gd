class_name CardController extends RefCounted

signal card_played(card: Card)

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
func can_play(card: Card, caster: MapCharacter, hand: Hand, target_cell: Vector2i) -> bool:
	# ensure the card or character actually exist
	if card == null or caster == null:
		return false
	# ensure the card is in the player's hand
	if not hand.hand.has(card):
		return false
	# Turn: compare against whoever is active
	if TurnManager.instance().get_character_turn() != "Player":
		return false
	# Mana: ask the character's pool
	if not caster.mana_pool.can_play_card(card.get_mana_cost()):
		return false
	# Ensure that the card is played on a valid target
	return target_cell in card.get_valid_targets(caster, HexMap.instance())

# When playing the card
func play_card(card: Card, caster: MapCharacter, hand: Hand, target_cell: Vector2i) -> bool:
	if not can_play(card, caster, hand, target_cell):
		return false
	var effect := card.build_effect(caster, target_cell)
	if effect == null:
		return false
		
	caster.mana_pool.deplete_mana(card.get_mana_cost())
	caster.mana_pool.mana_changed()
	effect.apply()
	hand.remove_card(card)
	card_played.emit(card)
	return true
