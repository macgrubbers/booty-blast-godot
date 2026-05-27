extends Node

class_name State

var prev_in_air_velocity:Vector3

signal transitioned
signal just_landed

func enter(_char_reference : CharacterBody3D):
	#enter state
	pass
	
func exit():
	#exit state
	pass
	
func update(_delta : float):
	#process update
	pass
	
func physics_update(_delta : float):
	#physics_process update
	pass 
