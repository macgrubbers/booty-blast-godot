class_name CoinCollectable extends BaseCollectable

var value:int = 1
var num_ticks_skip:int = 5
var num_ticks:int = 0
@export var spin_rate : float = 720

func _ready() -> void:
	if physicsable:
		spin_rate = 0
	super._ready()

func _physics_process(delta: float) -> void:
	if num_ticks >= num_ticks_skip:
		rotation.y -= deg_to_rad(spin_rate) * delta
		num_ticks = 0
	
	num_ticks += 1
