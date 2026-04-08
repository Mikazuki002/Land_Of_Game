class_name EnemyStateWander extends EnemyStates

@export var anim_name : String = "walk"
@export var wander_speed : float  = 20.0
@export_category("AI")
@export var state_animation_duration : float = 0.5
@export var state_cycles_min : int = 1
@export var state_cycles_max : int = 3
@export var next_state : EnemyStates

var _timer : float = 0.0
var _direction : Vector2


#Initialize on what will happen when initializing the State
func init() -> void:
	
	pass

#Entering the State
func enter() -> void:
	_timer = randi_range(state_cycles_min, state_cycles_max) * state_animation_duration
	var random = randf_range(0, 3)
	_direction = enemy.DIR_4[random]
	enemy.velocity = _direction * wander_speed
	enemy.setDirection(_direction)
	enemy.updateAnimation(anim_name)
	pass

#Exiting the Sate
func exit() -> void:
	
	pass


func process(_delta : float) -> EnemyStates:
	_timer -= _delta
	if _timer <= 0:
		return next_state
	return null


func physics(_delta : float) -> EnemyStates:
	
	
	return null
