class_name FinishFlag extends Area3D

@export var finish_message:String


func _ready() -> void:
	$Sketchfab_Scene/AnimationPlayer.play("KeyAction")
# Get the finish message
func get_finish_message():
	return finish_message
