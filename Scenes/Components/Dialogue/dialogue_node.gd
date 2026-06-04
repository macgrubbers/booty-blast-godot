extends Node
class_name DialogueNode

# Variables
## The text that will be "said" by the actor.
@export_multiline var dialogue_text:Array[String]

## The new state for the actor to transition to, leave empty if none.
@export var dialogue_state:String

## The dictionary holding dialogue responses for the player to choose from. These are organized in pairs of linked Nodes and dialogue "responses".
@export var dialogue_responses:Dictionary[DialogueNode, String]
