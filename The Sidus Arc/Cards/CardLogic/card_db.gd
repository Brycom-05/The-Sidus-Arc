class_name CardDatabase extends RefCounted
# ADD CARDS HERE

# Using a dictionary to store our different cards
###############################
## card objects labeled by id
## id: int {
## 	title: String
## 	mana_cost: int
## 	capabilities: Array[CardCapability]
## }
static var CARDS: Dictionary = {
	1: {
		"title": "fireball",
		"mana_cost": 3,
		"capabilities": [
			{"type": "attack"},
			{"attack_range": 3},
			{"damage": 2}
		]
	},
	
	2: {
		"title": "mana blast",
		"mana_cost": 1,
		"capabilities": [
			{"type": "attack"},
			{"attack_range": 2},
			{"damage": 1}
		]
	},
	
	3: {
		"title": "ice blast",
		"mana_cost": 2,
		"capabilities": [
			{"type": "attack"},
			{"attack_range": 3},
			{"damage": 1}
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

## Helper to build a full starter deck from an array of IDs.[br]
## [param card_ids]: an array of card ids
static func create_deck_from_ids(card_ids: Array[int]) -> Deck:
	var cards: Array[Card] = []
	for id: int in card_ids:
		var card: Card = create_card(id)
		if card != null:
			cards.push_back(card)
	return Deck.new(cards)

## Helper to build capabilities that a card has[br]
## [param cap_data]: the listed capabilities in card's capabilities
static func _build_capabilities(cap_data: Dictionary) -> CardCapability:
	
	# if capability is not a valid type, err
	# changed from match, since cards move and attack
	if cap_data["type"] != "move" and cap_data["type"] != "attack":
		printerr("Unknown capability type: ", cap_data["type"])
		return null
	else:
		if cap_data["type"] == "move":
			return MoveCapability.new(cap_data["movement_range"])
		if cap_data["type"] == "attack":
			# AttackCapability
			# max_attack_range: int
			# damage: int
			# get_attacked_tiles: Callable
			return AttackCapability.new(cap_data["attack_range"], cap_data["damage"], cap_data["get_attacked"])
		printerr("Unknown capability type: ", cap_data["type"])
		return null
