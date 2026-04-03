extends Node
class_name DialogueManagerComponent

@export var starting_dialogue_node:DialogueNode
@onready var current_dialogue_node:DialogueNode = starting_dialogue_node
@onready var prev_dialogue_node:DialogueNode

# Get the dialogue text of the current node
func get_current_dialogue_node_text():
	if current_dialogue_node.dialogue_text:
		return current_dialogue_node.dialogue_text.pick_random()
	else:
		return "ERROR: NO TEXT FOUND ON NODE " + current_dialogue_node.get_name()
	
func get_current_dialogue_node_state():
	return current_dialogue_node.dialogue_state

# Get the responses of the current node
func get_current_dialogue_node_responses():
	return current_dialogue_node.dialogue_responses

 # Switch to a new dialogue node
func switch_dialogue_nodes(new_node:DialogueNode):
	prev_dialogue_node = current_dialogue_node
	var first_key = current_dialogue_node.dialogue_responses.keys()[0]
	current_dialogue_node = current_dialogue_node.dialogue_responses[first_key]
