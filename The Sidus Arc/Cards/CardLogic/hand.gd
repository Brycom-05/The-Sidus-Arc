class_name Hand extends RefCounted

static var DEFAULT_HAND_SIZE: int = 5

var hand: Array[Card]
var deck: Deck

func _init(p_deck: Deck, hand_size: int = DEFAULT_HAND_SIZE) -> void:
	self.deck = p_deck
	hand.resize(hand_size)

# Utilizes simple reshuffle when too low
func refresh_hand() -> void:
	if deck.get_cards_left_in_deck() < DEFAULT_HAND_SIZE:
		deck.reshuffle_deck()
	hand = deck.draw_cards(DEFAULT_HAND_SIZE)

func pick_random() -> Card:
	return hand.pick_random()

# Remove a card and place it in the discard pile
func play_card(card: Card, character: MapCharacter) -> bool:
	if not CardController.instance().can_play_card(card, character, self):
		return false

	character.deplete_mana(card.get_mana_cost())
	# TODO do card effect
	hand.erase(card)
	deck.discard.add(card)
	
	return true
