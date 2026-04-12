extends HealthComponent

@onready var kill_timer = $KillTimer
@onready var state_machine = $"../EnemyStateMachine"


func change_health(amount : float, attacker_position:Vector3=Vector3.ZERO):
	state_machine.on_player_hurt()
	super(amount)
	


func start_kill_timer():
	$KillTimer.start()
