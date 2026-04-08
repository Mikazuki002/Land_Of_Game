class_name EnemyStates extends Node

# Stores a reference to the enemy that this state belongs to...
var enemy : Enemy
var state_machine : EnemyStatesMachine


#Initialize on what will happen when initializing the State
func init() -> void:
	
	pass

#Entering the State
func enter() -> void:
	
	pass

#Exiting the Sate
func exit() -> void:
	
	pass


func process(_delta : float) -> EnemyStates:
	
	return null


func physics(_delta : float) -> EnemyStates:
	
	
	return null
