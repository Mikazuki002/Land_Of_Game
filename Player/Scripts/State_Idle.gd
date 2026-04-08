class_name State_Idle extends State

@onready var walk: State_Walk = $"../Walk"
@onready var attack: State_Attack = $"../Attack"

# What happens when the player enter's this state
func enter() -> void:
	player.updateAnimation("idle")
	pass
	
	
func exit() -> void:
	
	pass
	
	
func process(_delta : float) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null
	
	
func handleInput(_event : InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	
	if _event.is_action_pressed("interact"):
		PlayerManager.interact_pressed.emit()
	return null
	
	
func physics(_delta : float) -> State:
	
	return null
