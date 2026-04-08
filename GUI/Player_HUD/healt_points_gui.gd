class_name HealthPoints extends Control


@onready var sprite_2d: Sprite2D = $Sprite2D


var value : int = 2 : 
	set(_value) : 
		value = _value
		updateSprite()




func updateSprite() -> void:
	sprite_2d.frame = value
