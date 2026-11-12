extends Control

const HOVER_OFFSET := -8.0
const HOVER_DURATION := 0.2

@onready var artwork: TextureRect = $Artwork

var hover_tween: Tween


func _ready() -> void:
	mouse_entered.connect(_animate_hover.bind(HOVER_OFFSET, Tween.TRANS_BACK))
	mouse_exited.connect(_animate_hover.bind(0.0, Tween.TRANS_QUAD))


func _animate_hover(target_y: float, transition: Tween.TransitionType) -> void:
	if hover_tween != null:
		hover_tween.kill()
	hover_tween = create_tween().set_trans(transition).set_ease(Tween.EASE_OUT)
	hover_tween.tween_property(artwork, "position:y", target_y, HOVER_DURATION)
