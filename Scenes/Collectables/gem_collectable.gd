class_name GemCollectable extends BaseCollectable

var value:int = 1
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var gem_varieties =   [preload("res://Assets/crystals_pack/gem1.res"), 
								preload("res://Assets/crystals_pack/gem2.res"), 
								preload("res://Assets/crystals_pack/gem3.res"), 
								preload("res://Assets/crystals_pack/gem4.res"), 
								preload("res://Assets/crystals_pack/gem5.res"), 
								preload("res://Assets/crystals_pack/gem6.res"), 
								preload("res://Assets/crystals_pack/gem7.res")]

func _ready() -> void:
	mesh.set_mesh(gem_varieties.pick_random())
