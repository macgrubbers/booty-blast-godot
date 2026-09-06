class_name InactionableStatusEffect extends StatusEffect

func _init() -> void:
	effect_name = "Inactionable"
	stackable = false

func apply(char: CharacterBody3D) -> void:
	super.apply(char)
	target.health_component.inactionable = true

func remove() -> void:
	target.health_component.inactionable = false
