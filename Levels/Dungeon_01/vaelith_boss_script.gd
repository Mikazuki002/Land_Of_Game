class_name Vaelith extends Node2D

@export var max_hp : int = 10
var hp : int = 10

var current_position : int = 0
var positions : Array[Vector2]





@onready var animation_player: AnimationPlayer = $BossNode/AnimationPlayer
@onready var boss_node: Node2D = $BossNode
@onready var persistent_data_handler: PersistentDataHandler = $PersistentDataHandler
@onready var hurt_box: HurtBox = $BossNode/HurtBox
@onready var hit_box: Hitbox = $BossNode/HitBox
@onready var animation_damage: AnimationPlayer = $BossNode/Animation_Damage



func _ready() -> void:
	hp = max_hp
	
	hit_box.damaged.connect(damage_taken)
	
	
	for c in $PositionTargets.get_children():
		positions.append(c.global_position)
	
	print(positions)
	$PositionTargets.visible = false
	
	
	


func _process(delta: float) -> void:
	pass


func damage_taken(_hurt_box : HurtBox) -> void:
	if animation_damage.current_animation == "damaged" or _hurt_box.damage == 0:
		return
	hp = clampi(hp - _hurt_box.damage, 0, max_hp)
	
	animation_damage.play("damaged")
	animation_damage.seek(0)
	animation_damage.queue("default")
	
	
	
	
	if hp < 1:
		defeat()
	
	pass



func defeat() -> void:
	animation_player.play("destroy")
	enable_hit_box(false)
	persistent_data_handler.set_value()
	await animation_player.animation_finished


func enable_hit_box(_v : bool = true) -> void:
	hit_box.set_deferred("monitorable", _v) 
	hurt_box.set_deferred("monitoring", _v) 
