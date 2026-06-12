extends StaticBody3D

class_name button

@export var linked_object:Node
@export var button_delay:float



func interact():
	if linked_object and linked_object.has_method("activate"):
		linked_object.activate()
