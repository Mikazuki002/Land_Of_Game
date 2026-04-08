extends CanvasLayer


var hearts : Array[HealthPoints] = []



func _ready() -> void:
	for child in $Control/HFlowContainer.get_children():
		if child is HealthPoints:
			hearts.append(child)
			child.visible = false
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
