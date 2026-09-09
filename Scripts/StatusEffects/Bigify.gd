class_name BigifyStatusEffect extends StatusEffect

func _init(dur:int) -> void:
	effect_name = "Bigify"
	stackable = false
	duration = dur

func apply(char: CharacterBody3D) -> void:
	super.apply(char)
	target.bigify_hitbox.monitoring = true
	target.is_changing_size = true
	target.new_size = char.sizes.LARGE
	target.health_component.defense_level = 4

func remove() -> void:
	target.bigify_hitbox.monitoring = false
	target.is_changing_size = true
	target.new_size = target.sizes.NORMAL
	target.health_component.defense_level = 1
