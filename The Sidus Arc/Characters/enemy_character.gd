class_name EnemyCharacter extends MapCharacter

var _hand: Hand

func _init(p_deck: Deck, sprite_texture: Texture2D = null) -> void:
	super()
	team = Team.ENEMY
	if sprite_texture == null:
		modulate = Color(1, 0.4, 0.4)
	else:
		var sprite_size := texture.get_size() * scale
		texture = sprite_texture
		scale = Vector2.ONE * (sprite_size.x / texture.get_width())
		texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	_hand = Hand.new(p_deck)
	_hand.draw_starting_hand()

# next turn we draw a card
func next_turn() -> void:
	_card_effects.clear()
	_hand.draw_card()

# FOR TESTING
# picks a random card and applies it
func pick_move() -> bool:
	var options: Array[Dictionary] = []
	for card in _hand.hand:
		for cell in card.get_valid_targets(self, HexMap.instance()):
			options.append({"card": card, "cell": cell})

	if options.is_empty():
		return false
	
	var choice: Dictionary = options.pick_random()
	var card: Card = choice["card"]
	var effect := card.build_effect(self, choice["cell"])
	if effect == null:
		return false
	
	queue_effect(effect)
	_hand.remove_card(card)
	return true

#func pick_move() -> Array[CardEffect]:
	# TODO: AI GOES HERE
	#var selected_card: Card = _hand.pick_random()
	
	#for effect: CardCapability in selected_card.get_capabilities():
		#_card_effects.push_back(effect.create_effect(_tile, _tile + Vector2i(0, -2)))
   # return _card_effects
