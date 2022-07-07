class_name LinkedPortal extends Reference

var pos:Vector2 # TileMap Position, not WorldCoords
var linkedRoom:Reference # LinkedRoom actually

func _init(a_pos:Vector2) -> void:
	var LinkedRoom = load("res://globals/models/LinkedRoom.gd") # circumventing circular dependency
	
	pos = a_pos
	
	var size:Vector2 = GlobalsMain.getRandomVector2(
			GlobalsMain.ROOM_MIN_WIDTH, 
			GlobalsMain.ROOM_MAX_WIDTH, 
			GlobalsMain.ROOM_MIN_HEIGHT, 
			GlobalsMain.ROOM_MAX_HEIGHT)
	
	linkedRoom = LinkedRoom.new(size.x, size.y)

func hasRoom() -> bool:
	return linkedRoom != null && linkedRoom.isInitialized

func getTileMapPosition() -> Vector2:
	return pos;

func generateRoom() -> void:
	if !hasRoom():
		linkedRoom.generate()
		
