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
