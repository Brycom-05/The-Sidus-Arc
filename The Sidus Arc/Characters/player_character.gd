class_name PlayerCharacter extends MapCharacter

const WIZARD_TEXTURE: Texture2D = preload("res://UI/PlayerUI/wizard.png")

var hand: Hand
var _dragging := false
var _grab_offset := Vector2.ZERO
var _resting_z_index := 0

func _init(p_deck: Deck) -> void:
	super()
	texture = WIZARD_TEXTURE
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	scale = Vector2.ONE
	# Rest the wizard's feet slightly below the tile center.
	offset = Vector2(0, -18)
	
	hand = Hand.new(p_deck)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and is_visible_in_tree() and get_rect().has_point(get_local_mouse_position()):
			_dragging = true
			_grab_offset = global_position - get_global_mouse_position()
			_resting_z_index = z_index
			z_index = 100
			get_viewport().set_input_as_handled()

func _input(event: InputEvent) -> void:
	if not _dragging:
		return
	if event is InputEventMouseMotion:
		global_position = get_global_mouse_position() + _grab_offset
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		_finish_drag()
		get_viewport().set_input_as_handled()

func _finish_drag(cancelled: bool = false) -> void:
	_dragging = false
	z_index = _resting_z_index
	var map := HexMap.instance()
	# Use the sprite's tile anchor as the landing point rather than
	# the cursor, which may be grabbing the hat several tiles above the feet.
	if not cancelled:
		global_position = get_global_mouse_position() + _grab_offset
	var destination := map.base_layer.local_to_map(map.base_layer.to_local(global_position))
	if cancelled or not map.can_place_character(self, destination):
		destination = get_tile()
	map.move_character(self, destination)

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT and _dragging:
		_finish_drag(true)

func next_turn() -> void:
	_card_effects.clear()
	
	hand.refresh_hand()
	
	# Input here
