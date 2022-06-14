class_name Door extends Reference

var pos:Vector2
var linkedRoom:LinkedRoom

func _init(a_pos:Vector2) -> void:
	pos = a_pos

func hasRoom() -> bool:
	return linkedRoom != null

func setRoom(room:LinkedRoom) -> void:
	linkedRoom = room
