class_name State_Attack extends State

var attacking : bool = false

@onready var walk: State_Walk = $"../Walk"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var idle: State_Idle = $"../Idle"

@onready var hurt_box: HurtBox = %AttackHurtBox

# What happens when the player enter's this state
func enter() -> void:
	player.updateAnimation("attack")
	animation_player.animation_finished.connect(endAttack)
	attacking = true
	
	await get_tree().create_timer(0.075).timeout
	if attacking:
		hurt_box.monitoring = true
	
	pass
	
	
func exit() -> void:
	animation_player.animation_finished.disconnect(endAttack)
	attacking = false
	hurt_box.monitoring = false
	pass
	
	
func process(_delta : float) -> State:
	
	player.velocity = Vector2.ZERO
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null
	
	
func handleInput(_input : InputEvent) -> State:
	
	return null
	
	
func physics(_delta : float) -> State:
	
	return null
	
func endAttack(_newAnimName : String) -> void:
	attacking = false
