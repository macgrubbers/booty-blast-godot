extends CanvasLayer

@onready var player = $".."
@onready var dialogue_box = $DialogueBox
@onready var dialogue_holder_label = $DialogueBox/ColorRect/Label
var speaker:DialogueManagerComponent


# Start a conversation with the speaker
func start_conversation(speaker_component:DialogueManagerComponent):
	speaker = speaker_component
	dialogue_box.visible = true
	get_current_dialogue_node()


func get_current_dialogue_node():
	if speaker:
		var speaker_dialogue = speaker.get_current_dialogue_node_text()
		dialogue_holder_label.text = speaker_dialogue

func get_next_dialogue_node():
	if speaker:
		speaker.switch_dialogue_nodes()

# End a conversation with the speaker
# Sets speaker to null
func end_conversation():
	speaker = null
	dialogue_box.visible = false
