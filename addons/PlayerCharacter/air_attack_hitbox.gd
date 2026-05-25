class_name AirAttackHitbox extends PlayerBaseHitbox

@onready var player: CharacterBody3D = $"../.."

func _on_area_entered(area: Area3D) -> void:
	if player.velocity.y <= 0:
		return
	
	super(area)
