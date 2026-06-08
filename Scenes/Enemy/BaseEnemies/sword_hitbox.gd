extends BaseHitbox

@onready var visuals = $"../VisualRoot/LilGooberVisuals"

func _ready() -> void:
	visuals.connect("toggle_hitbox", toggle)
