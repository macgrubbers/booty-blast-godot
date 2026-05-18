extends MeshInstance3D

@onready var barrel = $Barrel
@onready var projectile:PackedScene = preload("res://Scenes/Projectiles/TestBullet.tscn")
@onready var projectile_speed


func fire(target_pos:Vector3):
	var new_projectile = projectile.instantiate()
	get_tree().current_scene.add_child(new_projectile)
	new_projectile.speed = 30
	new_projectile.setup(barrel.global_position, target_pos + Vector3(0,1,0))
	new_projectile.shooter = self
	
	
