class_name PlayerBaseHitbox extends BaseHitbox


func _ready() -> void:
	connect("body_entered", _on_body_entered)
	super._ready()

func _on_body_entered(body:Node3D):
	body.attack(damage)
	return
