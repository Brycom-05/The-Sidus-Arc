class_name Hand extends RefCounted

static var DEFAULT_HAND_SIZE: int = 5

var hand: Array[Card]
var deck: Deck

func _init(p_deck: Deck, hand_size: int = DEFAULT_HAND_SIZE) -> void:
	self.deck = p_deck

# Draw starting hand by default hand size
func draw_starting_hand() -> void:
	_draw(DEFAULT_HAND_SIZE)

# Drawing one card at a time
func draw_card() -> void:
	_draw(1)

# Draw card by amount
# Shuffle discard pile back into draw pile when deck is depleted
func _draw(amount: int) -> void:
	if deck.get_cards_left_in_deck() < amount:
		deck.reshuffle_deck()
	hand.append_array(deck.draw_cards(amount))

func pick_random() -> Card:
	return hand.pick_random()
	
# remove card from hand and send to discard pile
func remove_card(card: Card) -> void:
	hand.erase(card)
	deck.discard.add(card)

# Remove a card and place it in the discard pile
func play_card(card: Card, character: MapCharacter) -> bool:
	if not CardController.instance().can_play_card(card, character, self):
		return false

	character.mana_pool.deplete_mana(card.get_mana_cost())
	# TODO do card effect
	hand.erase(card)
	deck.discard.add(card)
	
	return true
