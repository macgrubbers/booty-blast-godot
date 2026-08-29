extends PathFollow3D

enum move_mode{LOOP, TOGGLEABLE_LOOP, TOGGLEABLE_INCREMENT}
@export var current_mode:move_mode
@export var path:Path3D
@export var current_point_index:int

@export_group("Toggleable Mode Options")
@export var toggle_forwards:Node3D
@export var toggle_backwards:Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path = get_parent()
	if (current_mode == move_mode.TOGGLEABLE_LOOP or 
		current_mode == move_mode.TOGGLEABLE_INCREMENT):
			setup_toggleable()


# Setup movement for toggleable mode
func setup_toggleable():
	if toggle_forwards.has_signal("pressed"):
		toggle_forwards.connect("pressed", _on_forwards_pressed)
	
	if toggle_backwards.has_signal("pressed"):
		toggle_backwards.connect("pressed", _on_backwards_pressed)

func _on_forwards_pressed():
	print("Forwards pressed")
	move_toggleable_increment(1)

func _on_backwards_pressed():
	print("Backwards pressed")
	move_toggleable_increment(-1)

func move_toggleable_increment(next_index_dir:int):
	var curve: Curve3D = path.curve
	var total_points: int = curve.point_count
	
	# Increment the index and wrap around if the path loops
	var next_point_index = current_point_index + next_index_dir
	if ((next_point_index <= 0) or
		(next_point_index > total_points - 1)):
		print ("Can't move!")
		return
	else:
		current_point_index = next_point_index

	# Get the distance along the path for the specific point index
	var point_offset: float = curve.get_offset(current_point_index)
	
	# Update the PathFollow3D position instantly
	progress = point_offset
