class_name Vaelith extends Node2D

const ENERGY_EXPLOSION : PackedScene = preload("res://Enemies/Final_Boss/energy_explosion.tscn")


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

	await get_tree().process_frame
	for c in $PositionTargets.get_children():
		positions.append(c.global_position)
	$PositionTargets.visible = false
	print(positions)
	teleport(1)




func _process(delta: float) -> void:
	pass

func teleport(_location : int) -> void:
	animation_player.play("disappear")
	enable_hit_box(false)

	await get_tree().create_timer(1).timeout
	boss_node.global_position = positions[_location]
	current_position = _location
	
	animation_player.play("appear")
	await animation_player.animation_finished
	idle()
	pass

func idle() -> void:
	enable_hit_box()
	
	animation_player.play("idle")
	await animation_player.animation_finished
	
	var _t : int = current_position
	while _t == current_position:
		_t = randi_range(0,1)
	teleport(_t)
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


func explosion(_p : Vector2 = Vector2.ZERO) -> void:
	var e : Node2D = ENERGY_EXPLOSION.instantiate()
	
	e.global_position = boss_node.global_position + _p
	get_parent().add_child.call_deferred(e)
	
	pass
