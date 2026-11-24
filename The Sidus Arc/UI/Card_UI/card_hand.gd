extends Control

const CARD_SIZE := Vector2(150, 240)
const CARD_SPACING := 70.0
const FAN_ANGLE := 11.0
const FAN_DROP := 6.25
const PEEK := 80.0
const HOVER_LIFT := 40.0
const FLIP_DURATION := 0.55
const CARD_BACK := preload("res://UI/Card_UI/back_of_card.png")
const CardSounds := preload("res://UI/Card_UI/card_sounds.gd")
const STAGE_ONE_CARDS: Dictionary[String, Texture2D] = {
	"Dash": preload("res://UI/Card_UI/StageOne_Cards/stage1_dash.png"),
	"Fireball": preload("res://UI/Card_UI/StageOne_Cards/stage1_fireball.png"),
	"Ice Blast": preload("res://UI/Card_UI/StageOne_Cards/stage1_iceblast.png"),
	"Mana Blast": preload("res://UI/Card_UI/StageOne_Cards/stage1_manablast.png"),
	"Wind Blast": preload("res://UI/Card_UI/StageOne_Cards/stage1_windblast.png"),
}

@onready var actions: HBoxContainer = $Actions
@onready var card_sounds: CardSounds = $CardSounds
@onready var play_button: Button = $Actions/Cast

var cards: Array[TextureButton] = []
var movements: Dictionary[TextureButton, Tween] = {}
var selected_card: TextureButton
var hovered_card: TextureButton
var card_by_button: Dictionary[TextureButton, Card] = {}
var hand: Hand
var character: MapCharacter

func _ready() -> void:
	$Actions/Back.pressed.connect(_return_card)
	play_button.pressed.connect(_play_selected)
	resized.connect(_layout)
	_layout()

func setup(p_hand: Hand, p_character: MapCharacter) -> void:
	if is_instance_valid(character):
		character.mana_pool.update_mana_ui.disconnect(_update_play_button)
	hand = p_hand
	character = p_character
	character.mana_pool.update_mana_ui.connect(_update_play_button)
	_build_cards()

# Builds the cards
func _build_cards() -> void:
	# remove old cards
	for old in cards:
		if movements.has(old):
			movements[old].kill()
		old.queue_free()
	cards.clear()
	card_by_button.clear()
	movements.clear()
	selected_card = null
	hovered_card = null
	actions.hide()
	
	for card_data in hand.hand:
		if card_data == null:
			continue
		var button := _make_card_button(card_data)
		add_child(button)
		cards.append(button)
		card_by_button[button] = card_data
	_layout()

# creates the card as a button
func _make_card_button(card_data: Card) -> TextureButton:
	var button := TextureButton.new()
	button.texture_normal = _art_for(card_data)
	button.ignore_texture_size = true
	button.stretch_mode = TextureButton.STRETCH_SCALE
	button.size = CARD_SIZE	
	button.pivot_offset = Vector2(CARD_SIZE.x / 2.0, CARD_SIZE.y)
	button.accessibility_name = card_data.get_title()
	button.mouse_entered.connect(_on_card_hover.bind(button))
	button.mouse_exited.connect(_on_card_exit.bind(button))
	button.pressed.connect(_select_card.bind(button))
	return button

# grabs the art for the card
func _art_for(card_data: Card) -> Texture2D:
	var key := card_data.get_title().capitalize()
	if not STAGE_ONE_CARDS.has(key):
		push_warning("No card art for: " + key)
		return null
	return STAGE_ONE_CARDS[key]

# updates to play button
func _update_play_button() -> void:
	if selected_card == null:
		return
	var card_data: Card = card_by_button[selected_card]
	# disable the play button if we can't play it
	play_button.disabled = not CardController.instance().can_play_card(card_data, character, hand)

# play the selected card
func _play_selected() -> void:
	if selected_card == null:
		return
	var button := selected_card
	var card_data: Card = card_by_button[button]
	
	# if cannot play card
	if not hand.play_card(card_data, character):
		return
	
	# if play is successful, remove the card visual
	selected_card = null
	actions.hide()
	cards.erase(button)
	card_by_button.erase(button)
	if movements.has(button):
		movements[button].kill()
		movements.erase(button)
	
	var fade := create_tween()
	fade.tween_property(button, "modulate:a", 0.0, 0.2)
	fade.tween_callback(button.queue_free)
	
	# re-enable cards in hand, and re-fan
	for hand_card in cards:
		hand_card.disabled = false
		_move_card(hand_card)

func _fan_slot(card: TextureButton) -> float:
	return cards.find(card) - (cards.size() - 1) / 2.0


func _card_angle(card: TextureButton) -> float:
	return 0.0 if card == selected_card else _fan_slot(card) * FAN_ANGLE


func _card_position(card: TextureButton) -> Vector2:
	if card == selected_card:
		return (size - CARD_SIZE) / 2.0

	var slot := _fan_slot(card)
	var x := (size.x - CARD_SIZE.x) / 2.0 + slot * CARD_SPACING
	var lift := HOVER_LIFT if card == hovered_card else 0.0
	return Vector2(x, size.y - PEEK + absf(slot) * FAN_DROP - lift)


func _layout() -> void:
	for card in cards:
		if movements.has(card):
			movements[card].kill()
		card.position = _card_position(card)
		card.rotation_degrees = _card_angle(card)
		_set_card_flip(0.0, card)

	actions.position = Vector2(
		(size.x - actions.get_combined_minimum_size().x) / 2.0,
		(size.y + CARD_SIZE.y) / 2.0 + 12.0
	)

# Move the card to a position
func _move_card(card: TextureButton, flip: bool = false) -> void:
	if movements.has(card):
		movements[card].kill()
	var duration := FLIP_DURATION if flip else 0.18
	var movement := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	movement.tween_property(card, "position", _card_position(card), duration)
	movement.parallel().tween_property(card, "rotation_degrees", _card_angle(card), duration)
	if flip:
		movement.parallel().tween_method(_set_card_flip.bind(card), 0.0, TAU, duration).set_trans(Tween.TRANS_LINEAR)
	movements[card] = movement

# Flip card
func _set_card_flip(angle: float, card: TextureButton) -> void:
	var facing := cos(angle)
	card.scale.x = maxf(absf(facing), 0.01)
	# Selected cards are disabled during the flip, so swap their disabled face.
	card.texture_disabled = CARD_BACK if facing < 0.0 else null

# Hover
func _on_card_hover(card: TextureButton) -> void:
	if selected_card == null:
		hovered_card = card
		_move_card(card)

# Un-hover
func _on_card_exit(card: TextureButton) -> void:
	if hovered_card == card:
		hovered_card = null
		_move_card(card)

# Selecting a card
func _select_card(card: TextureButton) -> void:
	if selected_card != null:
		return
	card_sounds.play_pull()
	selected_card = card
	hovered_card = null
	for hand_card in cards:
		hand_card.disabled = true
		_move_card(hand_card, hand_card == selected_card)
	card.z_index = 1
	_update_play_button()
	actions.show()
	$Actions/Back.grab_focus()

# Puts card back into hand
func _return_card() -> void:
	var card := selected_card
	if card == null:
		return
	card_sounds.play_back()
	selected_card = null
	actions.hide()
	card.z_index = 0
	_move_card(card)
	_set_card_flip(0.0, card)
	for hand_card in cards:
		hand_card.disabled = false
