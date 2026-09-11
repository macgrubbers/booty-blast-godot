class_name DestructableRigidBody3D extends RigidBody3D

@onready var health:int = 1
@onready var defense_level:int = 3

func attack(attack_level:int, attack_damage:int):
	# Is attack successful?
	if attack_level < defense_level:
		return
	
	health -= attack_damage
	if health <= 0:
		shatter()


func shatter():
	$CollisionShape3D.disabled = true
	for child in get_children():
		if child is RigidBody3D:
			child.freeze = false
