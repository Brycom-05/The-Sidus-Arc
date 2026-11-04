class_name CardController extends RefCounted

static var _instance: CardController = CardController.new()

# Check if there is an instance for CardController, if not make one
static func instance() -> CardController:
	if _instance == null:
		printerr("Singleton not created yet.")
	return _instance

# Execute chard effect
# param [character]: which character is enacting the effect
# param [effect]: the effect on a character
func execute_card_effect(character: MapCharacter, effect: CardEffect) -> void:
	if effect is MoveEffect:
		HexMap.instance().move_character(character, effect.get_destination())
		
# Checks if a card can be played
# TODO
#func can_play_card() -> bool:
	#var mana = get_mana()
	#var turn = get_characters_turn()
	
	# if enough mana and turn == "Player":
	# 	return true
	# else:
	#	return false
