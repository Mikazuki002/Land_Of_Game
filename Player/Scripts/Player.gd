class_name Player extends CharacterBody2D

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
var cardinal_direct : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

@onready var state_machine: Node = $StateMachine

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machines: PlayerStateMachine = $StateMachine
@onready var hit_box: Hitbox = $HitBox

signal directionChanged(new_direction : Vector2)
signal player_damaged(hurt_box : HurtBox)

var invulnerable : bool = false
var hp : int = 6
var max_hp : int = 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.initialize(self)
	hit_box.damaged.connect(_take_damage)
	updateHP(99)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	pass

func _physics_process(_delta):
	
	move_and_slide()
	
	
	
func setDirection() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int(round((direction + cardinal_direct * 0.1).angle() / TAU * DIR_4.size()))
	var new_dir = DIR_4[direction_id]
	
	if new_dir == cardinal_direct: 
		return false
		
		
	cardinal_direct = new_dir
	directionChanged.emit(new_dir)
	sprite_2d.scale.x = 1 if cardinal_direct == Vector2.LEFT else -1
	
	return true


func updateAnimation(state : String) -> void:
	animation_player.play(state + "_" + animDirection())
	
	
	pass


func animDirection() -> String:
	if cardinal_direct == Vector2.DOWN:
		return "down"
	elif cardinal_direct == Vector2.UP:
		return "up"
	else:
		return "side"	
		

func _take_damage(hurt_box : HurtBox) -> void:
	print("take_damage called, invulnerable: ", invulnerable)
	if invulnerable == true:
		return
	updateHP(-hurt_box.damage)
	if hp > 0:
		player_damaged.emit(hurt_box)
	else:
		player_damaged.emit(hurt_box)

		updateHP(99)
	
	pass

func updateHP(delta : int) -> void:
	hp = clampi(hp + delta, 0, max_hp)
	PlayerHealth.update_HP(hp, max_hp)
	pass


func makeInvulnerable(_duration : float = 1.0) -> void:
	invulnerable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer(_duration).timeout
	
	invulnerable = false
	hit_box.monitoring = true
	pass
