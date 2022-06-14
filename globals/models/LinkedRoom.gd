class_name LinkedRoom extends Reference

var width:int = 0
var height:int = 0
var tiles:Array2D # 2D Array of ints
var exits:Array = [] # Array of Exits

func _init(a_width:int, a_height:int) -> void:
	width = a_width
	height = a_height
	tiles = Array2D.new(width, height)
	exits = []
