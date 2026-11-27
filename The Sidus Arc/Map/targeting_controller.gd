class_name TargetingController extends Node

const VALID_COLOR := Color(1.0, 1.0, 1.0, 0.45)
const INVALID_COLOR := Color(1.0, 0.2, 0.2, 0.45)

var hand_ui: Control
var player: PlayerCharacter
var hand: Hand
var pending_card: Card
var valid_targets: Array[Vector2i] = []
var _hover_cell := Vector2i(-1, -1)

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
	print("begin targeting")
	pending_card = card
	valid_targets = card.get_valid_targets(player, HexMap.instance())
	
	# if no valid targets, cancel and return card to hand
	if valid_targets.is_empty():
		hand_ui.cancel_selection()
		return
	HexMap.instance().set_range_cells(valid_targets)
	_hover_cell = Vector2i(-1, -1)

# Update hover marker when cursor moves to a new tile
func _process(_delta: float) -> void:
	if pending_card == null:
		return
	print("hover process running")
	var cell := HexMap.instance().cell_under_mouse()
	if cell == _hover_cell:
		return
	_hover_cell = cell
	_update_hover(cell)

# set the updated color of the cell
func _update_hover(cell: Vector2i) -> void:
	var map := HexMap.instance()
	if map.base_layer.get_cell_source_id(cell) == -1:
		map.clear_hover()
		return
	var center_valid := cell in valid_targets
	var colors: Dictionary[Vector2i, Color] = {}
	# Updating colors for targeting with radii
	for footprint_cell in map.get_footprint(cell, pending_card.get_area_radius()):
		if not center_valid or map.mountain_cells.has(footprint_cell):
			colors[footprint_cell] = INVALID_COLOR
		else:
			colors[footprint_cell] = VALID_COLOR
	map.set_hover_cells(colors)

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
	_hover_cell = Vector2i(-1, -1)
	var map := HexMap.instance()
	map.clear_range()
	map.clear_hover()
