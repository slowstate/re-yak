class_name StateMachine

extends Node

@export var CURRENT_STATE: State
signal update_state(State)
var states: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(on_child_transition)
		else:
			push_warning("State machine contains incompatible child node")
	CURRENT_STATE.enter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	CURRENT_STATE.update(delta)

func _physics_process(delta):
	CURRENT_STATE.physics_update(delta)

func on_child_transition(new_state_name: StringName) -> void:
	var new_state = states.get(new_state_name)
	if new_state != null:
		if new_state != CURRENT_STATE:
			#print("Current state: " + str(CURRENT_STATE.name) + " | New state: " + str(new_state.name))
			CURRENT_STATE.exit()
			new_state.enter()
			CURRENT_STATE = new_state
			update_state.emit(CURRENT_STATE)
		else:
			push_warning("State does not exist")
