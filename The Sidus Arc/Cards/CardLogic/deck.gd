class_name Deck extends RefCounted

var base_deck: Array[Card]
var current_deck: Array[Card]

func _init(p_base_deck: Array[Card]) -> void:
	base_deck = p_base_deck
	current_deck = base_deck

func draw_cards(num: int) -> Array[Card]:
	var cards: Array[Card] = []
	while not current_deck.is_empty() and cards.size() < num:
		cards.push_back(current_deck.pop_front())
	
	return cards

func get_cards_left_in_deck() -> int:
	return current_deck.size()

# TODO
func reshuffle_deck() -> void:
	current_deck = base_deck
	current_deck.shuffle()
