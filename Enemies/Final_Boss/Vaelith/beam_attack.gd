class_name BeamAttack extends Node2D

@export var use_timer : bool = false
@export var time_between_attacks : float  = 3

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_active : bool = true

func _ready() -> void:
	if use_timer == true:
		attack_delay()
	
	pass 





func attack() -> void:
	if not is_active:
		return
	animation_player.play("attack")
	await animation_player.animation_finished
	animation_player.play("default")
	
	
	if use_timer == true:
		attack_delay()




func attack_delay() -> void:
	await get_tree().create_timer(time_between_attacks).timeout
	if not is_active:        
		return
	attack()


func stop() -> void:         
	is_active = false
	animation_player.play("default")
