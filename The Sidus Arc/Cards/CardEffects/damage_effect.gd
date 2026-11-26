class_name DamageEffect extends CardEffect

var target_cell: Vector2i
var amount: int

func _init(p_target_cell: Vector2i, p_amount: int) -> void:
	target_cell = p_target_cell
	amount = p_amount
	
func get_affected_cells() -> Array[Vector2i]:
	return [target_cell]
	
func apply() -> void:
	var target := HexMap.instance().get_character_at(target_cell)
	if target != null and is_instance_valid(target):
		target.take_damage(amount)
