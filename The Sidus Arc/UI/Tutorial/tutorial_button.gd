extends CanvasLayer

signal start_tutorial

func _on_button_pressed() -> void:
	start_tutorial.emit()
