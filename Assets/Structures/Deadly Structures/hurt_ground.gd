extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Change the health of the player on hit
#	NOTE: This will only interface with the player's hurtbox
func _on_area_entered(area: Area3D) -> void:
	if area is HealthComponent:
		area.change_health(-20)
