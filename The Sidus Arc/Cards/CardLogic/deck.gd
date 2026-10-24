class_name Deck extends RefCounted

var base_deck: Array[Card]
var current_deck: Array[Card]

func _init(p_base_deck: Array[Card]) -> void:
	base_deck = p_base_deck

## TODO: Returns Array of size [code]min(num, current_deck.size())[/code]
func draw_cards(num: int) -> Array[Card]:
	return []

func get_cards_left_in_deck() -> int:
	return current_deck.size()

# TODO
func reshuffle_deck() -> void:
	pass
