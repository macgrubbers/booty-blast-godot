extends Node3D

func play_walk():
	$lil_goober_hostile/AnimationPlayer.play("Run")
	print("playing!")
