class_name Cutscene extends Control

signal finished

@export_multiline var text: String = ""

@onready var overlay: ColorRect = $Background
@onready var text_box: Control = $TextBox
@onready var label: Label = $TextBox/Margin/Label
@onready var portrait_left: TextureRect = get_node_or_null("PortraitLeft")
@onready var portrait_right: TextureRect = get_node_or_null("PortraitRight")


func _ready() -> void:
	label.text = text
	if portrait_right:
		portrait_right.modulate = Color(1, 0.4, 0.4)

func fade_to_black(duration: float = 0.8) -> void:
	text_box.visible = false
	if portrait_left:
		portrait_left.visible = false
	if portrait_right:
		portrait_right.visible = false
	var t := create_tween()
	t.tween_property(overlay, "color:a", 1.0, duration)
	await t.finished

func fade_from_black(duration: float = 0.8) -> void:
	var t := create_tween()
	t.tween_property(overlay, "color:a", 0.647, duration)
	await t.finished

# for skipping in cutscenes
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_viewport().set_input_as_handled()
		finished.emit()
