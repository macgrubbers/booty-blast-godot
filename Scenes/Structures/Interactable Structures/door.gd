extends AnimatableBody3D

@export var is_locked:bool = true
@onready var is_opened:bool = false
@onready var anim_player:AnimationPlayer = $AnimationPlayer



func interact():
	if is_locked:
		var unlock_successful = try_to_unlock()
		
		if unlock_successful:
			anim_player.play("Open")
			is_opened = true
	else:
		if is_opened:
			is_opened = false
			anim_player.play_backwards("Open")
		else:
			is_opened = true
			anim_player.play("Open")

func try_to_unlock():
	if PlayerData.keys > 0:
		is_locked = false
		PlayerData.keys -= 1
		$lock.visible = false
		return true
	return false
