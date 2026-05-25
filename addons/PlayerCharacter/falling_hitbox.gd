extends BaseHitbox

@export var self_knockback_amount: float = 10
@onready var player: CharacterBody3D = $".."

func _on_area_entered(area: Area3D) -> void:
	if player.velocity.y >= 0:
		return
	
	super(area)
	print("head stomp")
	player.velocity.y = 0
	player.health_component.apply_knockback(Vector3(0,self_knockback_amount,0),false)
