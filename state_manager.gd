extends Node
class_name State_Manager
@onready var player: Player = $".."

var states : Dictionary = {}
var current_state : States
@export var initial_state : States
var state_name : String

func _ready():
	for child in get_children():
		if child is States:
			states[child.name.to_lower()] = child
			child.transition.connect(change_state)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
	#print(current_state.name)
func _process(delta):
	if current_state:
		current_state.Update(delta)

func _physics_process(delta):
	if current_state:
		current_state.Phy_Update(delta)

func change_state(source_state, new_state_name):
	if source_state != current_state:
		print("Bad state " + source_state.name + " current state: " + current_state.name)
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		print("No state")
		return
	
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	
	current_state = new_state

func get_state_name():
	state_name = current_state.name
	return state_name
