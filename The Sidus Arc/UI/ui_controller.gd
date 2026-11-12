class_name UIController extends Node

static var _instance: UIController = UIController.new()

# signals for game-logic to wait on
signal player_ends_plan_phase
signal card_effect_animation_ended

static func instance() -> UIController:
	if _instance == null:
		printerr("Singleton not created yet.")
	return _instance

## TODO Call after resolution phases
func play_effect(card_effect: CardEffect) -> void:
	# Play animation
	# Update ui for those effects
	card_effect_animation_ended.emit()
	
