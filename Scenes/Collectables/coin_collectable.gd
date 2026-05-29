class_name CoinCollectable extends BaseCollectable

var value:int = 1

func _ready() -> void:
	if physicsable:
		spin_rate = 0
	super._ready()
