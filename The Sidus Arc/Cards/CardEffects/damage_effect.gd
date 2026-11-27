class_name DamageEffect extends CardEffect

var source: MapCharacter
var target_cells: Array[Vector2i]
var amount: int

func _init(p_source: MapCharacter, p_cells: Array[Vector2i], p_amount: int) -> void:
	source = p_source
	target_cells = p_cells
	amount = p_amount
	
func get_affected_cells() -> Array[Vector2i]:
	return target_cells
	
func apply() -> void:
	for cell in target_cells:
		var target := HexMap.instance().get_character_at(cell)
		if target != null and is_instance_valid(target):
			target.take_damage(amount)
