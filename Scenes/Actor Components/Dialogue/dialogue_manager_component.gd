extends Node
class_name DialogueManagerComponent

@export var starting_dialogue_node:DialogueNode
@onready var curr_dialogue_node:DialogueNode = starting_dialogue_node
@onready var prev_dialogue_node:DialogueNode

signal transition_states(dialogue_state:String)

# Check if we have a starting dialogue node, complain if there's not
func _on_ready() -> void:
	if !starting_dialogue_node:
		print("ERROR: Starting dialogue node not set!")


# Get the dialogue text and responses of the current node
#	Emits a transition states signal with the desired new state string
func get_current_dialogue_node():
	var dialogue_state = curr_dialogue_node.dialogue_state
	if dialogue_state:
		transition_states.emit(dialogue_state)
	var dialogue_text = curr_dialogue_node.dialogue_text
	var dialogue_responses = curr_dialogue_node.dialogue_responses
	var dialogue_node_array = [dialogue_text, dialogue_responses]
	return dialogue_node_array
	
# Switch to a new dialogue node
#	Will revert to the old node if the new one cannot be found (and yell at you)
func switch_dialogue_nodes(new_node:String):
	prev_dialogue_node = curr_dialogue_node
	curr_dialogue_node = self.find_child(new_node)
	if !curr_dialogue_node:
		print("ERROR: Switch to new dialogue node " + new_node +" failed!")
		curr_dialogue_node = prev_dialogue_node
