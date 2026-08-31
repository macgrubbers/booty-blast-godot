class_name EnemyBlackboard extends Blackboard

func _ready():
	set_value("is_alive", true)
	set_value("just_attacked", false)
	set_value("attack_successful", false)
	set_value("see_player", false)
	set_value("last_seen_player_pos", Vector3.ZERO)
	set_value("in_attack_range",false)
	set_value("can_attack", false)
	set_value("has_task", false)
	set_value("is_navigation_finished",true)
	set_value("player_just_lost", false)
	set_value("can_patrol", false)
	set_value("is_dancing", false)
	
	
	$"../HealthComponent".connect("new_effect_applied", _on_new_effect_applied)
	$"../HealthComponent".connect("effect_removed", _on_effect_removed)
	
func _on_new_effect_applied(new_effect:String):
	if new_effect == "Boogie":
		set_value("is_dancing", true)

func _on_effect_removed(new_effect:String):
	if new_effect == "Boogie":
		set_value("is_dancing", false)
