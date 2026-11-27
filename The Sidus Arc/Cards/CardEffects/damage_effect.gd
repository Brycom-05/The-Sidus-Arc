class_name DamageEffect extends CardEffect

const FLOAT_OFFSET := Vector2(0, -40)
const DAMAGE_COLOR := Color(1.0, 0.3, 0.3)

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
	# a caster that died during the turn cannot finish its attack
	if not is_instance_valid(source) or source.is_dead:
		return
	var map := HexMap.instance()
	for cell in target_cells:
		var target := HexMap.instance().get_character_at(cell)
		if target != null and is_instance_valid(target):
			target.take_damage(amount)
		var text_position := target.global_position + FLOAT_OFFSET
		target.flash_hit()
		map.spawn_floating_text(text_position, "-%d" % amount, DAMAGE_COLOR)
		target.take_damage(amount)
