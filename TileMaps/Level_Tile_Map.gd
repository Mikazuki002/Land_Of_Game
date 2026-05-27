class_name LevelTileMap extends TileMap

func _ready() -> void:
	LevelManager.changeTileMapBounds(getTileMapBounds())

func getTileMapBounds() -> Array[Vector2]:
	var bounds : Array[Vector2] = []
	var rect = get_used_rect()
	var tile_size = tile_set.tile_size
	var local_top_left = Vector2(rect.position * tile_size)
	var local_bottom_right = Vector2(rect.end * tile_size)
	bounds.append(to_global(local_top_left))
	bounds.append(to_global(local_bottom_right))
	return bounds
