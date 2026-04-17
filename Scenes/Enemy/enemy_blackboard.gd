extends Blackboard


func _ready():
	set_value("is_alive", health_component.is_alive, self.to_string())
	set_value("node#", self)
	blackboard = new_blackboard
