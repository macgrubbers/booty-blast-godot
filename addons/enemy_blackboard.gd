class_name EnemyBlackboard extends Blackboard

@onready var main_scene = $".."

func _ready():
	set_value("player_ref",main_scene.player_ref)
