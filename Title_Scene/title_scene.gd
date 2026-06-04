extends Node2D

const START_LEVEL : String = "res://playground.tscn"

@onready var new_game: Button = $CanvasLayer/Control/New_Game
@onready var load_game: Button = $CanvasLayer/Control/Load_Game


func _ready() -> void:
	
	get_tree().paused = true
	if PlayerManager.player != null and is_instance_valid(PlayerManager.player):
		PlayerManager.player.visible = false
	
	PlayerHealth.visible = false
	PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
	
	if SaveManager.get_save_file() == null:
		load_game.disabled = true
		load_game.visible = false
	
	setup_title_screen()
	LevelManager.level_load_started.connect(exit_title_screen)
	pass



func setup_title_screen() -> void:
	new_game.pressed.connect(start_game)
	new_game.grab_focus()
	
	load_game.pressed.connect(loadGame)
	pass

func start_game() -> void:
	LevelManager.load_new_level(START_LEVEL, "", Vector2.ZERO)
	
	pass



func loadGame() -> void:
	SaveManager.load_game()
	
	pass


func exit_title_screen() -> void:
	if PlayerManager.player != null and is_instance_valid(PlayerManager.player):
		PlayerManager.player.visible = true
	
	PlayerHealth.visible = true
	PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	self.queue_free()
	
	pass
