extends CanvasLayer

@onready var player = $".."
@onready var dialogue_box = $DialogueBox
@onready var dialogue_holder_label = $DialogueBox/ColorRect/Label

var speaker:DialogueManagerComponent
var dialogue_node_array: Array

# Start a conversation with the speaker
func start_conversation(speaker_component:DialogueManagerComponent):
	speaker = speaker_component
	dialogue_box.visible = true
	get_current_dialogue_node()


func get_current_dialogue_node():
	if speaker:
		dialogue_node_array = speaker.get_current_dialogue_node()
		var dialogue = dialogue_node_array[0]
		var responses = dialogue_node_array[1]
		
		# TODO: Determine if we should do a dialogue or response box!
		#	TODO: OR maybe theyre the same idk
		dialogue_holder_label.text = dialogue.pick_random()




#func get_next_dialogue_node():
	#if speaker:
		#speaker.switch_dialogue_nodes()


# End a conversation with the speaker
# Sets speaker to null
func end_conversation():
	speaker = null
	dialogue_box.visible = false
