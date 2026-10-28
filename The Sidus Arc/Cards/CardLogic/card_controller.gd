class_name CardController extends RefCounted

static var _instance: CardController = CardController.new()

static func instance() -> CardController:
	if _instance == null:
		printerr("Singleton not created yet.")
	return _instance


func execute_card_effect(character: MapCharacter, effect: CardEffect) -> void:
	if effect is MoveEffect:
		HexMap.instance().move_character(character, effect.get_destination())
		
