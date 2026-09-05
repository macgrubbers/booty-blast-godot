extends Control


@onready var level_select_button:Button = $LevelSelect
@onready var quit_button: Button = $Quit


func _ready() -> void:
	level_select_button.connect("pressed", _on_level_select_pressed)
	quit_button.connect("pressed", _on_quit_pressed)



func _on_level_select_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menus/LevelSelector.tscn")


func _on_quit_pressed():
	get_tree().quit()
