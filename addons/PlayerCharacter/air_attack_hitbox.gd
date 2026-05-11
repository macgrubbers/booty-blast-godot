extends BaseHitbox

@onready var player: CharacterBody3D = $"../.."

func _on_area_entered(area: Area3D) -> void:
	if player.global_velocity.y <= 0:
		return
	
	super(area)
