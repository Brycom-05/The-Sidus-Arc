extends Control

@onready var card_hand = $UIController/CardHand/Hand

func _ready() -> void:
	var ids: Array[int] = [1,2,3,4,1,2,3,4]
	var deck := CardDatabase.create_deck_from_ids(ids)
	
	var hand := Hand.new(deck)
	hand.refresh_hand()
	
	var character := MapCharacter.new()
	TurnManager.instance().set_character_turn("Player")
	
	card_hand.setup(hand, character)

	print("Hand: ", hand.hand.map(func(c: Card): return c.get_title()))
	character.mana_pool.update_mana_ui.connect(func():
		print("Mana: ", character.mana_pool.get_mana())
		print("Discard: ", deck.discard.cards.size()))
