extends Node
# class_name CurrentWorld 

var currentRoom : LinkedRoom

func _ready():
	_init_world_array()

func _init_world_array():
	var size:Vector2 = GlobalsMain.getRandomVector2(
		GlobalsMain.ROOM_MIN_WIDTH, 
		GlobalsMain.ROOM_MAX_WIDTH, 
		GlobalsMain.ROOM_MIN_HEIGHT, 
		GlobalsMain.ROOM_MAX_HEIGHT)
	currentRoom = LinkedRoom.new(size.x, size.y)
	
func generate() -> void:
	currentRoom.generate(1)
