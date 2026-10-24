class_name EnemyCharacter extends MapCharacter

var _hand: Hand

func _init(p_deck: Deck) -> void:
	super()
	
	_hand = Hand.new(p_deck)

func next_turn() -> void:
	_hand.refresh_hand()
	_selected_card = null

func pick_move() -> void:
	# TODO: AI GOES HERE
	_selected_card = _hand.pick_random()
