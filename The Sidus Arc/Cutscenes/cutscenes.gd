class_name Cutscene extends Control

signal finished

@export_multiline var text: String = ""
@export var slides: Array[CutsceneSlide] = []

@onready var overlay: ColorRect = $Background
@onready var text_box: Control = $TextBox
@onready var label: Label = $TextBox/Margin/Label
@onready var portrait_left: TextureRect = get_node_or_null("PortraitLeft")
@onready var portrait_right: TextureRect = get_node_or_null("PortraitRight")
#currently added skip button for testing, can remove after if needed
@onready var skip_button: Button = get_node_or_null("SkipButton") 

var _index: int = 0

func _ready() -> void:
	if portrait_right:
		portrait_right.modulate = Color(1, 0.4, 0.4)
	if slides.is_empty():
		label.text = text
	else:
		_show_slide(0)
	if skip_button:
		skip_button.pressed.connect(_on_skip_pressed)

func _on_skip_pressed() -> void:
	finished.emit()

func _show_slide(i: int) -> void:
	var slide: CutsceneSlide = slides[i]
	label.text = slide.text
	if portrait_left:
		portrait_left.visible = slide.show_left
	if portrait_right:
		portrait_right.visible = slide.show_right

func fade_to_black(duration: float = 0.8) -> void:
	text_box.visible = false
	if portrait_left:
		portrait_left.visible = false
	if portrait_right:
		portrait_right.visible = false
	if skip_button:
		skip_button.visible = false
	var t := create_tween()
	t.tween_property(overlay, "color:a", 1.0, duration)
	await t.finished

func fade_from_black(duration: float = 0.8) -> void:
	var t := create_tween()
	t.tween_property(overlay, "color:a", 0.647, duration)
	await t.finished

# for skipping within cutscenes
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if skip_button and skip_button.get_global_rect().has_point(event.position):
			return
		get_viewport().set_input_as_handled()
		_index += 1
		if _index >= slides.size():
			finished.emit()
		else:
			_show_slide(_index)
