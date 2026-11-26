class_name DamageEffect extends CardEffect

var target: MapCharacter
var amount: int

func _init(p_target: MapCharacter, p_amount: int) -> void:
	target = p_target
	amount = p_amount
	
func apply() -> void:
	if is_instance_valid(target):
		target.take_damage(amount)
