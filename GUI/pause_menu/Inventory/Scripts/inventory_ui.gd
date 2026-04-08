class_name Inventory extends Control

const INVENTORY_SLOT = preload("res://GUI/pause_menu/Inventory/Inventory_Slot.tscn")
var focus_index : int = 0

@export var data : InventoryData


func _ready() -> void:
	PauseMenu.show.connect(updateInventory)
	PauseMenu.hidden.connect(clearInventory) 
	clearInventory()
	data.changed.connect(onInventoryChanged)
	pass


func clearInventory() -> void:
	
	for c in get_children():
		c.queue_free()


func updateInventory(i : int = 0) -> void:
	for s in data.slots:
		var new_slots = INVENTORY_SLOT.instantiate()
		add_child(new_slots)
		new_slots.slot_data = s
		new_slots.focus_entered.connect(item_focused)
	
	await get_tree().process_frame
	get_child(i).grab_focus()

func item_focused() -> void:
	for i in get_child_count():
		if get_child(i).has_focus():
			focus_index = 1
			return
	pass

func onInventoryChanged() -> void:
	var i = focus_index
	clearInventory()
	updateInventory(i)
	
