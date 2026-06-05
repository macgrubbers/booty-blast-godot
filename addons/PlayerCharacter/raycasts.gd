extends Node3D

@onready var player_model_rotation = %VisualRoot
@onready var floor_raycast:RayCast3D = %FloorRaycast
@onready var interact_raycast:RayCast3D = $InteractRaycast
@onready var ledge_grab_raycast1:RayCast3D = $LedgeGrabRaycast1
@onready var ledge_grab_raycast2:RayCast3D = $LedgeGrabRaycast2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	var model_rotation = player_model_rotation.get_rotation()
	set_rotation(model_rotation)
