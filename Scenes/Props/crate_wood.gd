extends RigidBody3D

@onready var health_component:PropHealthComponent = $HealthComponent
@onready var debris = preload("res://Scenes/Props/CrateWood_Fragments.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_component.connect("kill", _on_object_destroyed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_object_destroyed():
	pass
	queue_free()
