extends Control

const CARD_SIZE := Vector2(120, 192)
const CARD_SPACING := 56.0
const FAN_ANGLE := 11.0
const FAN_DROP := 5.0
const PEEK := 64.0
const HOVER_LIFT := 32.0
const FLIP_DURATION := 0.55
const CARD_BACK := preload("res://UI/Card_UI/back_of_card.png")
const STAGE_ONE_CARDS: Dictionary[String, Texture2D] = {
	"Dash": preload("res://UI/Card_UI/StageOne_Cards/stage1_dash.png"),
	"Fireball": preload("res://UI/Card_UI/StageOne_Cards/stage1_fireball.png"),
	"Ice Blast": preload("res://UI/Card_UI/StageOne_Cards/stage1_iceblast.png"),
	"Mana Blast": preload("res://UI/Card_UI/StageOne_Cards/stage1_manablast.png"),
}

@onready var actions: HBoxContainer = $Actions

var cards: Array[TextureButton] = []
var movements: Dictionary[TextureButton, Tween] = {}
var selected_card: TextureButton
var hovered_card: TextureButton


func _ready() -> void:
	for card_name in STAGE_ONE_CARDS:
		var card := TextureButton.new()
		card.texture_normal = STAGE_ONE_CARDS[card_name]
		card.ignore_texture_size = true
		card.stretch_mode = TextureButton.STRETCH_SCALE
		card.size = CARD_SIZE
		card.pivot_offset = Vector2(CARD_SIZE.x / 2.0, CARD_SIZE.y)
		card.accessibility_name = card_name
		card.mouse_entered.connect(_on_card_hover.bind(card))
		card.mouse_exited.connect(_on_card_exit.bind(card))
		card.pressed.connect(_select_card.bind(card))
		add_child(card)
		cards.append(card)

	$Actions/Back.pressed.connect(_return_card)
	resized.connect(_layout)
	_layout()


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


func _set_card_flip(angle: float, card: TextureButton) -> void:
	var facing := cos(angle)
	card.scale.x = maxf(absf(facing), 0.01)
	# Selected cards are disabled during the flip, so swap their disabled face.
	card.texture_disabled = CARD_BACK if facing < 0.0 else null


func _on_card_hover(card: TextureButton) -> void:
	if selected_card == null:
		hovered_card = card
		_move_card(card)


func _on_card_exit(card: TextureButton) -> void:
	if hovered_card == card:
		hovered_card = null
		_move_card(card)


func _select_card(card: TextureButton) -> void:
	if selected_card != null:
		return
	selected_card = card
	hovered_card = null
	for hand_card in cards:
		hand_card.disabled = true
		_move_card(hand_card, hand_card == selected_card)
	card.z_index = 1
	actions.show()
	$Actions/Back.grab_focus()


func _return_card() -> void:
	var card := selected_card
	selected_card = null
	actions.hide()
	card.z_index = 0
	_move_card(card)
	_set_card_flip(0.0, card)
	for hand_card in cards:
		hand_card.disabled = false
