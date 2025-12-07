extends Control

var player_health
var heart_container = []

func _ready() -> void:
	heart_container = [$Health1, $Health2, $Health3]
	for item in heart_container:
		item.play()

func _process(delta: float) -> void:
	pass

func update_player_health(new_health:int):
	var player_health = new_health
	if player_health != heart_container.size():
		for i in range(heart_container.size(),player_health,-1):
			heart_container[i-1].visible = false
	else:
		for heart in heart_container:
			heart.visible = true
