class_name CardController extends RefCounted

signal card_played(card: Card)

static var _instance: CardController = CardController.new()

# Check if there is an instance for CardController, if not make one
static func instance() -> CardController:
	if _instance == null:
		printerr("Singleton not created yet.")
	return _instance

# Can we play the card?
func can_play(card: Card, caster: MapCharacter, hand: Hand, target_cell: Vector2i) -> bool:
	# If there is no card or caster
	if card == null or caster == null:
		print("cannot play: missing card or caster")
		return false
	# Can we place the card
	if not PlayerStateMachine.instance().get_player_can_place_cards():
		print("cannot play: plan phase is closed")
		return false
	# if hand doesn't have card
	if not hand.hand.has(card):
		print("cannot play: card is not in hand")
		return false
	# if no mana
	if not caster.mana_pool.can_play_card(card.get_mana_cost()):
		print("cannot play: not enough mana")
		return false
	# if a valid target
	if not (target_cell in card.get_valid_targets(caster, HexMap.instance())):
		print("cannot play: ", target_cell, " is not a valid target")
		return false
	return true

# When playing the card
func play_card(card: Card, caster: MapCharacter, hand: Hand, target_cell: Vector2i) -> bool:
	if not can_play(card, caster, hand, target_cell):
		return false
	var effect := card.build_effect(caster, target_cell)
	if effect == null:
		print("play_card: build_effect returned null for ", card.get_title())
		return false
	print("play_card: resolving ", card.get_title(), " on ", target_cell)
	caster.mana_pool.deplete_mana(card.get_mana_cost())
	caster.mana_pool.mana_changed()
	caster.queue_effect(effect)# using queue for effects now
	hand.remove_card(card)
	card_played.emit(card)
	return true
