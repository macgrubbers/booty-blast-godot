class_name CollectionComponent extends Area3D

@onready var player_ref:CharacterBody3D = $".."
@onready var health_component: HealthComponent = $"../HealthComponent"

signal just_collected(type:Area3D)

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body:Node3D):
	if body is HealthCollectable:
		health_component.heal(body.heal_amount)
		body.collect()
		
	elif body is CoinCollectable:
		PlayerData.moneys += body.value
		just_collected.emit(body)
		body.collect()
	
	elif body is BigBootyJuice:
		player_ref.is_changing_size = true
		player_ref.new_size = player_ref.sizes.LARGE
		player_ref.size_buff_timer.set_wait_time(body.duration)
		body.collect()
