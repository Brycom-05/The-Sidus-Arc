class_name UIController extends Node

static var _instance: UIController = null

# signals for game-logic to wait on
signal player_ends_plan_phase
signal card_effect_animation_ended

static func instance() -> UIController:
	if _instance == null:
		printerr("Singleton not created yet.")
	return _instance

func _ready() -> void:
	_instance = self

## TODO Call after resolution phases
func play_effect(card_effect: CardEffect) -> void:
	# Play animation
	# Update ui for those effects
	card_effect_animation_ended.emit()

func _on_end_turn_button_pressed() -> void:
	if PlayerStateMachine.instance().get_player_can_place_cards():
		print("Emit")
		player_ends_plan_phase.emit()
