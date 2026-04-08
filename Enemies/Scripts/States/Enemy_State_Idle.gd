class_name EnemyStateIdle extends EnemyStates

@export var anim_name : String = "idle"

@export_category("AI")
@export var state_duration_min : float = 0.5
@export var state_duration_max : float = 1.5
@export var after_idle_state : EnemyStates

var _timer : float = 0.0



#Initialize on what will happen when initializing the State
func init() -> void:
	
	pass

#Entering the State
func enter() -> void:
	enemy.velocity = Vector2.ZERO
	_timer = randf_range(state_duration_min, state_duration_max)
	enemy.updateAnimation(anim_name)
	pass

#Exiting the Sate
func exit() -> void:
	
	pass


func process(_delta : float) -> EnemyStates:
	_timer -= _delta
	if _timer <= 0:
		return after_idle_state
	return null


func physics(_delta : float) -> EnemyStates:
	
	
	return null
