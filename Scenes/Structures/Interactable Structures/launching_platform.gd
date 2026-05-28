class_name LaunchingPlatform extends AnimatableBody3D

@export var min_bounce_velocity: float = 3.0
@export var bounce_damp:float = 0.5
@export var max_bounce_mag:float = 36

func launch(body:HealthComponent,curr_state:State, prev_velocity:Vector3, collision_normal:Vector3):
	if prev_velocity.length() < min_bounce_velocity:
		return
	# TODO: animate when pressed down

	var velocity_dot_normal = prev_velocity.dot(collision_normal)
	var tangental_vel = prev_velocity - (collision_normal * velocity_dot_normal)

	var new_normal_vel = -collision_normal * velocity_dot_normal
	if curr_state is not ButtSlamState:
		new_normal_vel *= bounce_damp
	# Clamp collision normal velocity if it's too big
	if new_normal_vel.length() > max_bounce_mag:
		new_normal_vel = new_normal_vel.normalized() * max_bounce_mag
	print(new_normal_vel.length())
	
	body.apply_knockback(tangental_vel + new_normal_vel, false, true)
