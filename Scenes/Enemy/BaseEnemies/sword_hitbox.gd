extends BaseHitbox

@onready var visuals = $"../VisualRoot/LilGooberVisuals"

func _ready() -> void:
	visuals.connect("toggle_hitbox", toggle)

func _on_area_entered(area: Area3D) -> void:
	knockback_dir = owner.get_global_position().direction_to(area.get_owner().get_global_position()).normalized()
	super(area)
