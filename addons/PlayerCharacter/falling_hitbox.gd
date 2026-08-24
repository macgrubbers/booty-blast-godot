class_name FallingHitbox extends BaseHitbox

@export var self_knockback_amount: float = 10
@onready var player: CharacterBody3D = $".."

func _on_area_entered(area: Area3D) -> void:
	if player.velocity.y >= 0:
		return
	
	if player.state_machine.curr_state_name == "ButtSlam":
		attack_level = 3
	
	super(area)
	# apply knockback to self
	if area.get_owner().is_in_group("Enemies"):
		player.velocity.y = 0
		player.health_component.apply_knockback(Vector3(0,self_knockback_amount,0),false)
	
	attack_level = 1 # reset attack level if it was set
