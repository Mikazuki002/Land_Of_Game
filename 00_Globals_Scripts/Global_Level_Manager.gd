extends Node

signal level_load_started
signal level_loaded
signal tileMapBoundsChanged(bounds : Array[Vector2])

var current_tilemap_bounds : Array[Vector2]
var target_transition : String
var position_offset : Vector2

func _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit()

func changeTileMapBounds(bounds : Array[Vector2]) -> void:
	current_tilemap_bounds = bounds
	tileMapBoundsChanged.emit(bounds)


func load_new_level(
		levelPath : String,
		_target_transition : String,
		_position_offset : Vector2
) -> void:
	
	
	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _position_offset
	
	await SceneTransition.fade_out()
	level_load_started.emit()
	
	await get_tree().process_frame
	get_tree().change_scene_to_file(levelPath)
	
	
	await  SceneTransition.fade_in()
	await get_tree().process_frame
	
	_place_player()
	
	get_tree().paused = false
	
	level_loaded.emit()
	pass

func _place_player() -> void:
	var transition := get_tree().get_nodes_in_group("level_transition")
	for t in transition:
		if t.name == target_transition:
			PlayerManager.set_player_position(t.global_position + position_offset)
			return
	
	# Fallback: find PlayerSpawn node in the scene
	var spawn := get_tree().get_nodes_in_group("player_spawn")
	if spawn.size() > 0:
		PlayerManager.set_player_position(spawn[0].global_position)
		return
	
	push_warning("LevelManager: Could not find transition '%s'" % target_transition)
