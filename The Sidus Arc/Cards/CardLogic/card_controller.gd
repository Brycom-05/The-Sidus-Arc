class_name CardController extends RefCounted

static var _instance: CardController = CardController.new()

static func instance() -> CardController:
	if _instance == null:
		printerr("Singleton not created yet.")
	return _instance


func execute_card(character: MapCharacter, card: Card) -> void:
	pass
