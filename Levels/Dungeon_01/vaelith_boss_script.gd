class_name Vaelith extends Node2D

const ENERGY_EXPLOSION : PackedScene = preload("res://Enemies/Final_Boss/energy_explosion.tscn")


@export var max_hp : int = 10
var hp : int = 10

var current_position : int = 0
var positions : Array[Vector2]
var beam_attacks : Array[BeamAttack]

var damage_count : int = 0


@onready var boss_animation_player: AnimationPlayer = $BossNode/Vaelith_Boss/AnimationPlayer

@onready var animation_player: AnimationPlayer = $BossNode/AnimationPlayer
@onready var boss_node: Node2D = $BossNode
@onready var persistent_data_handler: PersistentDataHandler = $PersistentDataHandler
@onready var hurt_box: HurtBox = $BossNode/HurtBox
@onready var hit_box: Hitbox = $BossNode/HitBox
@onready var animation_damage: AnimationPlayer = $BossNode/Animation_Damage
@onready var door_block: TileMapLayer = $"../DoorBlock"



func _ready() -> void:
	persistent_data_handler.get_value()
	if persistent_data_handler.value == true:
		door_block.enabled = false
		queue_free()
		return
	
	
	hp = max_hp
	hit_box.damaged.connect(damage_taken)

	await get_tree().process_frame
	for c in $PositionTargets.get_children():
		positions.append(c.global_position)
	$PositionTargets.visible = false
	
	for b in $BeamAttacks.get_children():
		beam_attacks.append(b)
	
	teleport(3)


func energy_beam_attack() -> void:
	var _b : Array[int]
	match current_position:
		0, 2:
			if current_position == 0:
				_b.append(0)
				_b.append(randi_range(1,2))
			else:
				_b.append(2)
				_b.append(randf_range(0,1))
			if hp < 5:
				_b.append(randf_range(3,5))
			
			
			# Scale with difficulty
		1,3: 
			if current_position == 3:
				_b.append(2)
				_b.append(randi_range(1,2))
			else:
				_b.append(3)
				_b.append(randf_range(3,2))
			if hp < 5:
				_b.append(randf_range(3,5))
		
	for b in _b:
		beam_attacks[b].attack()
	

func _process(delta: float) -> void:
	pass

func teleport(_location : int) -> void:
	animation_player.play("disappear")
	enable_hit_box(false)
	
	damage_count = 0
	
	await get_tree().create_timer(1).timeout
	boss_node.global_position = positions[_location]
	current_position = _location
	
	
	update_animation()
	
	animation_player.play("appear")
	await animation_player.animation_finished
	idle()
	pass

func update_animation() -> void:
	
	boss_node.scale = Vector2(1,1)
	
	if current_position == 0:
		boss_animation_player.play("down")
	elif current_position == 2:
		boss_animation_player.play("up")
	else:
		boss_animation_player.play("side")
		if current_position == 1:
			boss_node.scale = Vector2(-1, 1)
	pass



func idle() -> void:
	enable_hit_box()
	
	if randf() >= float(hp) / float(max_hp):
		animation_player.play("idle")
		await animation_player.animation_finished
		if hp < 1:
			return
	
	
	
	animation_player.play("idle")
	await animation_player.animation_finished
	
	if hp < 1:        
		return
	
	if damage_count < 1:
		energy_beam_attack()
		animation_player.play("cast_spells")
		await  animation_player.animation_finished
		if hp < 1:    
			return
		
		
	if hp < 1:
		return
	
	
	
	var _t : int = current_position + 1
	if _t > 3:
		_t = 0
		
	
	teleport(_t)
	pass


func damage_taken(_hurt_box : HurtBox) -> void:
	if animation_damage.current_animation == "damaged" or _hurt_box.damage == 0:
		return
	hp = clampi(hp - _hurt_box.damage, 0, max_hp)
	
	damage_count += 1
	
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
	
	door_block.enabled = false
	
	


func enable_hit_box(_v : bool = true) -> void:
	hit_box.set_deferred("monitorable", _v) 
	hurt_box.set_deferred("monitoring", _v) 


func explosion(_p : Vector2 = Vector2.ZERO) -> void:
	var e : Node2D = ENERGY_EXPLOSION.instantiate()
	
	e.global_position = boss_node.global_position + _p
	get_parent().add_child.call_deferred(e)
	
	pass
