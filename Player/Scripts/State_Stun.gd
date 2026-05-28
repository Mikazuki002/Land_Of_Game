class_name State_Stun extends State


@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export var invulnerable_duration : float = 1.0

var hurt_box : HurtBox
var direction : Vector2

var next_state : State = null


@onready var idle: State_Idle = $"../Idle"
@onready var death: StateDeath = $"../Death"


func init() -> void:
	player.player_damaged.connect(_player_damaged)

# What happens when the player enter's this state
func enter() -> void:
	
	player.animation_player.animation_finished.connect(_animation_finished)
	
	
	direction = player.global_position.direction_to(hurt_box.global_position)
	player.velocity = direction * -knockback_speed
	player.setDirection()
	
	player.updateAnimation("stun")
	player.makeInvulnerable(invulnerable_duration)
	player.effect_animation_player.play("damaged")
	
	pass
	

	
	
func exit() -> void:
	next_state = null
	player.animation_player.animation_finished.disconnect(_animation_finished)

	pass
	
	
func process(_delta : float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	return next_state
	
	
func handleInput(_event : InputEvent) -> State:
	
	return null
	
	
func physics(_delta : float) -> State:
	
	return null


func _player_damaged(_hurt_box : HurtBox) -> void:
	hurt_box = _hurt_box
	
	if state_machine.current_state != death:
		state_machine.changeState(self)
	pass
	

func _animation_finished(_a : String) -> void:
	next_state = idle
	if player.hp <= 0:
		next_state = death
