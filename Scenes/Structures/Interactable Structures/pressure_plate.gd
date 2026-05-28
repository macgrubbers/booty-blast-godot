class_name PressurePlate extends StaticBody3D

@export var activating_node:Node

func activate():
	if activating_node:
		activating_node.activate()
	else:
		print("no activating node!")
