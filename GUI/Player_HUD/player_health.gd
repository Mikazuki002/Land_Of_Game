extends CanvasLayer


var hearts : Array[HealthPoints] = []

@onready var game_over: Control = $Control/Game_Over
@onready var continue_button: Button = $Control/Game_Over/VBoxContainer/Continue
@onready var back_to_title_button: Button = $Control/Game_Over/VBoxContainer/Back_to_Title
@onready var animation_player: AnimationPlayer = $Control/Game_Over/AnimationPlayer
@onready var boss_gui: Control = $Control/Boss_GUI
@onready var boss_texture_progress_bar: TextureProgressBar = $Control/Boss_GUI/TextureProgressBar
@onready var boss_label: Label = $Control/Boss_GUI/Label


func _ready() -> void:
	for child in $Control/HFlowContainer.get_children():
		if child is HealthPoints:
			hearts.append(child)
			child.visible = false
			
	
	# hide game over screen
	hide_game_over_screen()
	continue_button.pressed.connect(load_game)
	back_to_title_button.pressed.connect(title_screen)
	LevelManager.level_load_started.connect(hide_game_over_screen)
	
	hide_boss_health()
	
	
	pass 



func update_HP(_hp : int, _max_hp : int) -> void:
	updateMaxHP(_max_hp)
	for i in _max_hp: 
		updateHeart(i, _hp)
	
	pass


func updateHeart(_index : int, _hp : int) -> void:
	
	var _value : int = clampi(_hp - _index * 2, 0, 2)
	hearts[_index].value = _value
	
	pass



func updateMaxHP(_max_hp : int) -> void:
	var _heart_count : int = roundi(_max_hp * 0.5)
	for i in hearts.size():
		if i < _heart_count:
			hearts[i].visible = true
		else:
			hearts[i].visible = false
	pass

func show_game_over_screen() -> void:
	game_over.visible = true
	game_over.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var can_continue : bool = SaveManager.get_save_file() != null
	continue_button.visible = can_continue
	
	animation_player.play("show_game_over")
	
	await animation_player.animation_finished
	# focus on a button by default
	
	if can_continue == true:
		continue_button.grab_focus()
	else:
		back_to_title_button.grab_focus()
	

func hide_game_over_screen() -> void:
	game_over.visible = false
	game_over.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game_over.modulate = Color(1,1,1,0)
	


func load_game() -> void:
	await fade_game_over_screen()
	SaveManager.load_game()
	
	pass


func title_screen() -> void:
	await fade_game_over_screen()
	LevelManager.load_new_level("res://Title_Scene/title_scene.tscn", "", Vector2.ZERO)

func fade_game_over_screen() -> bool:
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	PlayerManager.player.revive_player()
	
	return true

func show_boss_health( boss_name : String) -> void:
	boss_gui.visible = true
	boss_label.text = boss_name
	update_boss_health(1,1)
	pass


func hide_boss_health() -> void:
	
	boss_gui.visible = false
	pass


func update_boss_health(hp : int, max_hp : int) -> void:
	
	boss_texture_progress_bar.value = clampf(float(hp) / float(max_hp) * 100, 0, 100)
	pass
