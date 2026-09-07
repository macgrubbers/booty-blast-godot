class_name BigifyStatusEffect extends StatusEffect

func _init(dur:int) -> void:
	effect_name = "Bigify"
	stackable = false
	duration = dur

func apply(char: CharacterBody3D) -> void:
	super.apply(char)
	target.is_changing_size = true
	target.new_size = char.sizes.LARGE

func remove() -> void:
	target.is_changing_size = true
	target.new_size = target.sizes.NORMAL
