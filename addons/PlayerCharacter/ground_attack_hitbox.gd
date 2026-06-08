class_name GroundAttackHitbox extends PlayerBaseHitbox

# TODO: find out why this knockbacks weird
func _ready() -> void:
	extra_vertical_knockback = Vector3(0,0.2,0)
	knockback_magnitude = 10
	connect("body_entered", _on_body_entered)
	super._ready()
