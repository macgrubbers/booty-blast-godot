extends PlayerBaseHitbox

func _ready() -> void:
	extra_vertical_knockback = Vector3(0,0.8,0)
	knockback_magnitude = 10
	connect("body_entered", _on_body_entered)
	super._ready()
