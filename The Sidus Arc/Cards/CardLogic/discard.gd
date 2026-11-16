class_name Discard extends RefCounted

var discard_pile: Array[Card]

# Add a card to the discard pile
func add(card: Card) -> void:
	discard_pile.push_back(card)

# Grabs all the cards in the discard pile
func take_all() -> Array[Card]:
	var result := discard_pile.duplicate()
	discard_pile.clear()
	return result
