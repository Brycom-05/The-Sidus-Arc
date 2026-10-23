class_name Hand extends RefCounted

static var DEFAULT_HAND_SIZE: int = 5

var hand: Array[Card]
var deck: Deck

func _init(p_deck: Deck, hand_size: int = DEFAULT_HAND_SIZE) -> void:
	self.deck = p_deck
	hand.resize(hand_size)
