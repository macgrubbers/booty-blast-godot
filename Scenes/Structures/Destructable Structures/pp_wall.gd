extends StaticBody3D


func attack():
	print("i've been hit")
	$CollisionShape3D.disabled = true
	for child in get_children():
		if child is RigidBody3D:
			child.freeze = false
