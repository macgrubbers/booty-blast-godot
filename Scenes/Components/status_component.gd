class_name StatusComponent extends Node


@onready var character: CharacterBody3D = get_parent()
var active_effects: Array[BaseStatusEffect] = []

signal new_effect_gained(effect:String)

func _process(delta: float) -> void:
	var expired_effects: Array[BaseStatusEffect] = []
	
	for effect in active_effects:
		effect.update(delta)
		if effect.is_expired():
		# Using stack or list collection to track expired items safely
			expired_effects.append(effect)
			
	for effect in expired_effects:
		remove_effect(effect)

func add_effect(new_effect: BaseStatusEffect) -> void:
	# Check if effect already exists to refresh duration instead of stacking
	for effect in active_effects:
		if effect.get_script() == new_effect.get_script():
			effect.time_elapsed = 0.0 # Refresh duration
			return
			
	active_effects.append(new_effect)
	new_effect.apply(character)
	new_effect_gained.emit(new_effect.effect_name)

func remove_effect(effect: BaseStatusEffect) -> void:
	effect.remove()
	active_effects.erase(effect)
