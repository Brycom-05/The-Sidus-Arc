class_name PlayerCharacter extends MapCharacter

var hand: Hand

func _init(p_deck: Deck) -> void:
	super()
	
	hand = Hand.new(p_deck)

func next_turn() -> void:
	_card_effect = null
	
	hand.refresh_hand()
