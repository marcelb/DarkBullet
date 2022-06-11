extends Node

const WIDTH = 200
const HEIGHT = 200

var world : Array
var isInitialized : bool = false

func _ready():
	_init_world_array()

func _init_world_array():
	world.resize(WIDTH)
	for n in HEIGHT:
		var newColumn:Array
		newColumn.resize(HEIGHT)
		world[n] = newColumn

func _process(delta):
	pass
	
func generate() -> void:
	var time_start = OS.get_ticks_msec()
	
	for x in WIDTH:
		for y in HEIGHT:
			world[x][y] = clamp(GlobalsMain.rng.randi_range(-160,1), -1, 1)
			
	print("World generating time: ", OS.get_ticks_msec() - time_start)
	isInitialized = true
	
