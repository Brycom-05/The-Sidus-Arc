class_name CardDatabase extends RefCounted
# ADD CARDS HERE

# Using a dictionary to store our different cards
###############################
## might be easier to label card objects by id
## id: int {
## 	title: String
## 	mana_cost: int
## 	capabilities: Array[CardCapability]
## }
const CARDS: Dictionary = {
	1: {
		"title": "attack",
		"mana_cost": 1,
		"capabilities": [
			{"type": "attack"}
		]
	}
}

# Create the card based on a card_id in the dictionary
static func create_card(card_id: int) -> Card:
	if not CARDS.has(card_id):
		printerr("Card ID not found in CardDatabase: ", card_id)
		return null
		
	var data: Dictionary = CARDS[card_id]
	var capabilities: Array[CardCapability] = []
	
	# go through capabilities and get capabilities
	for cap_data: Dictionary in data["capabilities"]:
		var capability: CardCapability = _build_capabilities(cap_data)
		if capability != null:
			capabilities.push_back(capability)
			
	# return card object
	return Card.new(
		card_id,
		data["title"],
		data["mana_cost"],
		capabilities
	)

# Helper to build a full starter deck from an array of IDs
static func create_deck_from_ids(card_ids: Array[int]) -> Deck:
# @param card_ids: an array of card ids
	var cards: Array[Card] = []
	for id: int in card_ids:
		var card: Card = create_card(id)
		if card != null:
			cards.push_back(card)
	return Deck.new(cards)

# Helper to build capabilities that a card has
static func _build_capabilities(cap_data: Dictionary) -> CardCapability:
# @param cap_data: the listed capabilities in card's capabilities
	match cap_data["type"]:
		"move":
			return MoveCapability.new(cap_data["range"])
		"attack":
			# AttackCapability
			# max_attack_range: int
			# damage: int
			# get_attacked_tiles: Callable
			return AttackCapability.new(cap_data["range"], cap_data["damage"], cap_data["get_attacked"])
		_:
			printerr("Unknown capability type: ", cap_data["type"])
			return null
