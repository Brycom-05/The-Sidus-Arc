class_name TargetingController extends Node

var hand_ui: Control
var player: PlayerCharacter
var hand: Hand
var pending_card: Card
var valid_targets: Array[Vector2i] = []

func _ready() -> void:
	# grab signals from hand_ui
	# when card is played, update hand and end targeting
	CardController.instance().card_played.connect(_on_card_played)

# Called by level once hand UI and player exist
func bind(p_hand_ui: Control, p_player: PlayerCharacter) -> void:
	hand_ui = p_hand_ui
	player = p_player
	hand = p_player.hand
	# on card play, begin targeting
	if not hand_ui.card_play_requested.is_connected(_begin_targeting):
		hand_ui.card_play_requested.connect(_begin_targeting)
	# on selection cancellation, clear targeting
	if not hand_ui.selection_cancelled.is_connected(_clear_targeting):
		hand_ui.selection_cancelled.connect(_clear_targeting)

# begin targeting
func _begin_targeting(card: Card) -> void:
	pending_card = card
	valid_targets = card.get_valid_targets(player, HexMap.instance())
	
	# if no valid targets, cancel and return card to hand
	if valid_targets.is_empty():
		hand_ui.cancel_selection()
		return
	var layer := HexMap.instance().highlight_layer
	layer.clear()
	for cell in valid_targets:
		layer.set_cell(cell, 0, Vector2i(0, 0))

# handle other key presses and mouse clicks
func _unhandled_input(event: InputEvent) -> void:
	if pending_card == null:
		return
	if event.is_action_pressed("ui_cancel"):
		hand_ui.cancel_selection()
		return
	# clicking
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var cell := HexMap.instance().cell_under_mouse()
		# invalid click still keeps targeting phase, so player can try again
		if CardController.instance().play_card(pending_card, player, hand, cell):
			get_viewport().set_input_as_handled()

# after card is played
func _on_card_played(card: Card) -> void:
	hand_ui.on_card_played(card)
	_clear_targeting()

# clear targeting
func _clear_targeting() -> void:
	pending_card = null
	valid_targets.clear()
	HexMap.instance().highlight_layer.clear()
