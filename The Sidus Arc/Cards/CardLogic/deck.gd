class_name Deck extends RefCounted

var base_deck: Array[Card]
var current_deck: Array[Card]

var discard: Discard = Discard.new()

func _init(p_base_deck: Array[Card]) -> void:
	base_deck = p_base_deck.duplicate()
	current_deck = base_deck.duplicate()
	current_deck.shuffle()

func draw_cards(num: int) -> Array[Card]:
	var cards: Array[Card] = []
	while not current_deck.is_empty() and cards.size() < num:
		cards.push_back(current_deck.pop_front())
	
	return cards

func get_cards_left_in_deck() -> int:
	return current_deck.size()

# Take the discard pile and reshuffle it back into the deck
func reshuffle_deck() -> void:
	current_deck.append_array(discard.take_all())
	current_deck.shuffle()
