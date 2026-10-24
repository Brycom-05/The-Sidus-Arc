class_name EnemyCharacter extends MapCharacter

var _hand: Hand

func _init(p_deck: Deck) -> void:
	super()
	modulate = Color(1, 0.4, 0.4)
	
	_hand = Hand.new(p_deck)
	next_turn()

func next_turn() -> void:
	_card_effect = null
	_hand.refresh_hand()

func pick_move() -> void:
	# TODO: AI GOES HERE
	var selected_card: Card = _hand.pick_random()
	
	_card_effect = selected_card.get_capability().create_effect(_tile, _tile + Vector2i(0, -2))
