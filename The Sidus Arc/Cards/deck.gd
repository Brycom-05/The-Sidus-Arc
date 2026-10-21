class_name Deck extends RefCounted

var base_deck: Array[Card]
var current_deck: Array[Card]

func _init(p_base_deck: Array[Card]) -> void:
	base_deck = p_base_deck

# TODO
func draw_cards(num: int) -> Array[Card]:
	return []

# TODO
func reshuffle_deck() -> void:
	pass
