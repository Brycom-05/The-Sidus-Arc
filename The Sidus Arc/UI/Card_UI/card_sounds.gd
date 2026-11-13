extends AudioStreamPlayer

const CARD_PULL := preload("res://Audio/Cards/card_pull.mp3")
const CARD_BACK := preload("res://Audio/Cards/card_back.mp3")


func play_pull() -> void:
	stream = CARD_PULL
	play()


func play_back() -> void:
	stream = CARD_BACK
	play()
