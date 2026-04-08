class_name HurtBox extends Area2D
@export var damage : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(areaEntered)
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func areaEntered(a : Area2D) -> void:
	if a is Hitbox:
		a.takeDamage(self)
	
	pass
