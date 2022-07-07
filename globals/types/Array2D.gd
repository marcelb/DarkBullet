# ---------------------------------
# Array2D
#
# In parts based on
# https://github.com/godot-extended-libraries/godot-next/blob/master/addons/godot-next/references/array_2d.gd
# ---------------------------------

class_name Array2D extends Reference

var data:Array = []

func _init(p_width:int, p_height:int) -> void:
	data.resize(p_width)
	for n in p_width:
		var newColumn:Array = []
		newColumn.resize(p_height)
		data[n] = newColumn

func clear() -> void:
	data = []

func get_data() -> Array:
	return data

func has_cell(p_x:int, p_y:int) -> bool:
	return len(data) > p_x and p_x > -1 and len(data[p_x]) > p_y and p_y > -1

func has_cellv(p_pos: Vector2) -> bool:
	return has_cell(p_pos.x, p_pos.y)

func get_cellv(p_pos: Vector2): # -> int or null
	if has_cellv(p_pos):
		return data[p_pos.x][p_pos.y]
	else:
		return null

func get_cell(p_x:int, p_y:int):
	return get_cellv(Vector2(p_x, p_y))

func set_cell(p_x:int, p_y:int, p_value):
	assert(has_cell(p_x, p_y))
	data[p_x][p_y] = p_value

func set_cellv(p_pos: Vector2, p_value):
	set_cell(p_pos.x, p_pos.y, p_value)

func isEmpty() -> bool:
	return len(data) == 0
