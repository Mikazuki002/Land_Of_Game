class_name TreeObject extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func takeDamage(_damage : HurtBox) -> void:
	queue_free()
	pass
