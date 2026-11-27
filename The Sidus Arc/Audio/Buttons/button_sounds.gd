extends Node

const CLICK_SFX := preload("res://Audio/Buttons/universfield-click-button-140881.mp3")

var _player: AudioStreamPlayer


func _ready() -> void:
	_player = AudioStreamPlayer.new()
	_player.stream = CLICK_SFX
	add_child(_player)

	get_tree().node_added.connect(_on_node_added)
	_connect_existing(get_tree().root)


func play_click() -> void:
	_player.play()


func _connect_existing(node: Node) -> void:
	_on_node_added(node)
	for child in node.get_children():
		_connect_existing(child)


func _on_node_added(node: Node) -> void:
	if node is BaseButton and not node.get_meta("skip_button_click", false):
		var button := node as BaseButton
		if not button.pressed.is_connected(play_click):
			button.pressed.connect(play_click)
