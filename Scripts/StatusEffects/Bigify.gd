class_name BigifyStatusEffect extends StatusEffect

func _init() -> void:
	effect_name = "Bigify"
	stackable = false

func apply(char: CharacterBody3D) -> void:
	super.apply(char)

func remove() -> void:
	pass
