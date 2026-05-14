extends MeshInstance3D

@onready var barrel = $Barrel
@onready var projectile:PackedScene = preload("res://Scenes/Projectiles/TestBullet.tscn")


func fire(target_pos:Vector3):
	var new_projectile = projectile.instantiate()
	new_projectile.setup(barrel.global_position, target_pos)
	new_projectile.shooter = self
	get_tree().current_scene.add_child(new_projectile)
	
	
