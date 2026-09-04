extends RigidBody3D

@onready var health_component:PropHealthComponent = $HealthComponent
@onready var debris = preload("res://Scenes/Props/CrateWood_Fragments.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_component.connect("dead", _on_object_destroyed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_object_destroyed():
	for i in range(10):
		var new_debris:RigidBody3D = debris.instantiate()
		var rand_vector = Vector3(randi_range(-10,10),
									randi_range(-10,10),
									randi_range(-10,10))
		new_debris.set_global_transform(get_global_transform())
		get_tree().current_scene.add_child(new_debris)
		new_debris.apply_central_impulse(rand_vector)
		new_debris.apply_torque_impulse(rand_vector)
		
	queue_free()
