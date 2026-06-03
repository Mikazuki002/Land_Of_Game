class_name PersistentDataHandler extends Node


signal data_loaded
var value : bool = false


func _ready() -> void:
	get_value()
	pass


func set_value() -> void:
	SaveManager.addPersistentValue(_get_name())
	pass


func get_value() -> void:
	value = SaveManager.checkPersistentValue(_get_name())
	data_loaded.emit(value)
	pass


func _get_name() -> String:
	# "res://levels/area01/01.tscn/treasurechest/PersistentDataHandler" - this will be the structure identifying it
	return get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name
