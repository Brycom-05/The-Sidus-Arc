class_name UIController extends Node2D

static var _instance: UIController = null

@onready var mana_bar: TextureProgressBar = $PlayerUI/Bars/Mana
@onready var main_camera: Camera2D = $MainCamera
@onready var card_hand_layer: CanvasLayer = $CardHand
@onready var player_ui_layer: CanvasLayer = $PlayerUI
@onready var end_turn_layer: CanvasLayer = $EndTurn

var _mana_pool: ManaPool

# signals for game-logic to wait on
signal player_ends_plan_phase
signal card_effect_animation_ended

static func instance() -> UIController:
	if _instance == null:
		printerr("Singleton not created yet.")
	return _instance

func _ready() -> void:
	_instance = self
	visibility_changed.connect(_sync_visibility)
	_sync_visibility()

func _sync_visibility() -> void:
	card_hand_layer.visible = visible
	player_ui_layer.visible = visible
	end_turn_layer.visible = visible
	main_camera.enabled = visible
	main_camera.set_process(visible)
	if visible:
		main_camera.make_current()

func show_player_hand(player: PlayerCharacter) -> void:
	$CardHand/Hand.setup(player.hand, player)
	if _mana_pool != null:
		_mana_pool.update_mana_ui.disconnect(_update_mana_bar)
	_mana_pool = player.mana_pool
	_mana_pool.update_mana_ui.connect(_update_mana_bar)
	_update_mana_bar()

func _update_mana_bar() -> void:
	mana_bar.value = _mana_pool.get_mana()

## TODO Call after resolution phases
func play_effect(card_effect: CardEffect) -> void:
	# Play animation
	# Update ui for those effects
	card_effect_animation_ended.emit()

func _on_end_turn_button_pressed() -> void:
	if PlayerStateMachine.instance().get_player_can_place_cards():
		$CardHand/Hand.cancel_selection() # turn off targeting at end turn
		print("Emit")
		player_ends_plan_phase.emit()

func _on_tutorial_button_start_tutorial() -> void:
	$Tutorial.start_tutorial()
