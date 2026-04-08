class_name EnemyStateStun extends EnemyStates

@export var anim_name : String = "stun"
@export var knockback_speed : float  = 200.0
@export var decelerate_speed : float = 10.0


@export_category("AI")
@export var next_state : EnemyStates

var _damage_position : Vector2
var _direction : Vector2
var _animation_finished : bool = false

#Initialize on what will happen when initializing the State
func init() -> void:
	enemy.enemy_damaged.connect(_on_enemy_damaged)
	pass

#Entering the State
func enter() -> void:
	enemy.invulnerable = true
	_animation_finished = false
	_direction = enemy.global_position.direction_to(_damage_position)
	enemy.setDirection(_direction)
	enemy.velocity = _direction * -knockback_speed
	
	enemy.updateAnimation(anim_name)
	enemy.animation_player.animation_finished.connect(_on_enemy_finished)
	pass

#Exiting the Sate
func exit() -> void:
	enemy.invulnerable = false
	enemy.animation_player.animation_finished.disconnect(_on_enemy_finished)
	pass


func process(_delta : float) -> EnemyStates:
	if _animation_finished == true:
		return next_state
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null


func physics(_delta : float) -> EnemyStates:
	
	
	return null


func _on_enemy_damaged(hurt_box : HurtBox) -> void:
	_damage_position = hurt_box.global_position
	state_machine.changeState(self)
	
	
	
func _on_enemy_finished( _a : String) -> void:
	_animation_finished = true
	
