extends HealthComponent

@onready var kill_timer = $KillTimer

func start_kill_timer():
	$KillTimer.start()
