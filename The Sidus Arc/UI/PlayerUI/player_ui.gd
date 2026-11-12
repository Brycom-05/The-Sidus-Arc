extends Control


func _ready() -> void:
	_bind_value($HP, $HP/Value, "HP")
	_bind_value($Mana, $Mana/Value, "Mana")


func _bind_value(bar: TextureProgressBar, label: Label, stat_name: String) -> void:
	var update_label := func(value: float) -> void:
		label.text = "%s\n%d" % [stat_name, value]
	bar.value_changed.connect(update_label)
	update_label.call(bar.value)
