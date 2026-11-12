class_name ManaPool extends RefCounted

signal update_mana_ui

var _mana_pool: float
var _recharge_rate: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_mana_pool = 0
	_recharge_rate = 0
	
func get_mana() -> float:
	return _mana_pool
	
# When a card is played, deplete mana
# param [mana_cost]: mana cost to play a card
func deplete_mana(mana_cost: float) -> void:
	if can_play_card(mana_cost):
		_mana_pool -= mana_cost
	
	
# Determines if a card can be played
# param [mana_cost]: mana cost to play a card
func can_play_card(mana_cost: float) -> bool:
	if (mana_cost > _mana_pool):
		return false
	else:
		return true

# Restore mana
# TODO
func recharge_mana() -> void:
	_mana_pool += 1
	
# This function emits a signal when mana changes
func mana_changed() -> void:
	update_mana_ui.emit()
