class_name CardDatabase extends RefCounted
# ADD CARDS HERE

# Using a dictionary to store our different cards
###############################
## card objects labeled by id
## id: int {
## 	title: String
## 	mana_cost: int
## 	capabilities: Array[CardCapability]
##		Each object is a movement or attack
## card_art: Texture2D
## }
static var CARDS: Dictionary = {
	1: {
		"title": "fireball",
		"mana_cost": 3,
		"capabilities": [
			{"type": "attack", "attack_range": 3, "damage": 2, "area": 1},
		],
	},
	
	2: {
		"title": "mana blast",
		"mana_cost": 1,
		"capabilities": [
			{"type": "attack", "attack_range": 2, "damage": 1}
		],
	},
	
	3: {
		"title": "ice blast",
		"mana_cost": 2,
		"capabilities": [
			{"type": "attack", "attack_range": 3, "damage": 1}
		],
	},
	
	4: {
		"title": "dash",
		"mana_cost": 1,
		"capabilities": [
			{"type": "movement", "movement_range": 2},
		]
	},

	5: {
		"title": "wind blast",
		"mana_cost": 1,
		"capabilities": [
			{"type": "attack", "attack_range": 2, "damage": 1}
		],
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
	match cap_data["type"]:
		"movement":
			return MoveCapability.new(cap_data["movement_range"])
		"attack":
			return AttackCapability.new(cap_data["attack_range"], cap_data["damage"])
	printerr("Unknown capability type: ", cap_data["type"])
	return null
