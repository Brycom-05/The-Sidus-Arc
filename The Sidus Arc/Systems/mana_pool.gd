class_name ManaPool extends RefCounted

signal update_mana_ui

var _mana_pool: float = 0.0
var _recharge_rate: float = 0.0

# initialize with starting mana
func _init(starting_mana: float) -> void:
	_mana_pool = starting_mana
	
func get_mana() -> float:
	return _mana_pool
	
# When a card is played, deplete mana
# param [mana_cost]: mana cost to play a card
func deplete_mana(mana_cost: float) -> void:
	if can_play_card(mana_cost):
		_mana_pool -= mana_cost
		update_mana_ui.emit()
	
	
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
	update_mana_ui.emit()
