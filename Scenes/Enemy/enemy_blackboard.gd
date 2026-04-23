class_name EnemyBlackboard extends Blackboard



func _ready():
	set_value("is_dead", false)
	set_value("just_attacked", false)
	set_value("see_player", false)
	set_value("in_attack_range",false)
	set_value("can_attack", false)
	set_value("has_task", false)
	
	
	for node in get_tree().current_scene.get_children():
		if node.is_in_group("Player"):
			set_value("player_ref", node)
