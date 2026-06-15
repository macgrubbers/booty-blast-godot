class_name CrateWoodFragments extends RigidBody3D

var value:int = 1
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var fragments = [preload("res://Assets/barrel__crate/Fragments/cratepiece1.res"), 
						preload("res://Assets/barrel__crate/Fragments/cratepiece2.res"), 
						preload("res://Assets/barrel__crate/Fragments/cratepiece3.res"), 
						preload("res://Assets/barrel__crate/Fragments/cratepiece4.res"), 
						preload("res://Assets/barrel__crate/Fragments/cratepiece5.res"), 
						preload("res://Assets/barrel__crate/Fragments/cratepiece6.res"), 
						preload("res://Assets/barrel__crate/Fragments/cratepiece7.res")]

func _ready() -> void:
	mesh.set_mesh(fragments.pick_random())
