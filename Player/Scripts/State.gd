class_name State extends Node

static var player: Player 
static var state_machine : PlayerStateMachine

func _ready() -> void:
	
	pass 

func init() -> void:
	pass

# What happens when the player enter's this state
func enter() -> void:
	
	pass
	
	
func exit() -> void:
	
	pass
	
	
func process(_delta : float) -> State:
	
	return null
	
	
func handleInput(_input : InputEvent) -> State:
	
	return null
	
func physics(_delta : float) -> State:
	
	return null
