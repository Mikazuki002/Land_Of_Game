class_name EnemyStatesMachine extends Node

var states : Array[EnemyStates]
var prev_state : EnemyStates
var current_state : EnemyStates


func _ready() -> void:
	process_mode =Node.PROCESS_MODE_DISABLED
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	changeState(current_state.process(delta))
	
	pass

func _physics_process(delta):
	changeState(current_state.physics(delta))

func initialize(_enemy : Enemy) -> void:
	states = []
	
	for c in get_children():
		if c is EnemyStates:
			states.append(c)
	
	for s in states:
		s.enemy = _enemy
		s.state_machine = self
		s.init()
		
	if states.size() > 0:
		changeState(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT


func changeState(new_state : EnemyStates) -> void:
	if new_state == null || new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
		
	prev_state = current_state
	current_state = new_state
	current_state.enter()
