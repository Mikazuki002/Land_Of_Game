@tool
class_name ItemPickup
extends CharacterBody2D

@export var item_data : ItemData : set = _set_item_data

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	
	updateTexture()
	if Engine.is_editor_hint():
		return
	
	if area_2d == null:
		push_error("Area2D is null!")
		return
	print("Iam:", self.name)
	print("Children", get_children())
	area_2d.body_entered.connect(onBodyEntered)

func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
	velocity -= velocity * delta * 4


func onBodyEntered(b) -> void:
	print("ENTERED: ", b.name, "CLASS", b.get_class() )
	
	if b is Player:
		if item_data:
			print("PLAYER DETECTED")
			if PlayerManager.INVENTORY_DATA.add_item(item_data) == true:
				itemPickedUp()
	pass


func itemPickedUp() -> void:
	area_2d.body_entered.disconnect(onBodyEntered)
	visible = false
	
	queue_free()
	
	pass

func _set_item_data(value : ItemData) -> void:
	item_data = value
	updateTexture()

func updateTexture() -> void:
	if item_data and sprite_2d:
		sprite_2d.texture = item_data.texture
	pass
