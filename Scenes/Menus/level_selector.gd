extends Control


@onready var sandbox:TextureButton = $TextureButton
@onready var steel_ball: TextureButton = $TextureButton2
@onready var quit:Button = $Quit


func _ready() -> void:
	sandbox.connect("pressed", _on_sandbox_pressed)
	steel_ball.connect("pressed", _on_steel_ball_pressed)
	quit.connect("pressed", _on_quit_pressed)


func _on_sandbox_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/SandboxLevel.tscn")


func _on_steel_ball_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_0.tscn")


func _on_quit_pressed():
	get_tree().quit()
