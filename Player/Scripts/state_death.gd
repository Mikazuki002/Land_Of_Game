class_name StateDeath extends State




func init() -> void:
	pass

# What happens when the player enter's this state
func enter() -> void:
	player.animation_player.play("death")
	
	#Trigger Game Over UI
	PlayerHealth.show_game_over_screen()
	pass
	
	
func exit() -> void:
	
	pass
	
	
func process(_delta : float) -> State:
	player.velocity = Vector2.ZERO
	return null
	
	
func handleInput(_input : InputEvent) -> State:
	
	return null
	
func physics(_delta : float) -> State:
	
	return null
