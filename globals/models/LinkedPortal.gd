class_name LinkedPortal extends Reference

var linkedRoom # LinkedRoom actually
var position: Vector2 # position of the Room in the linkedRoom
var destinationPortal # LinkedPortal of the room of the other side

func _init(a_linkedRoom:Reference, a_position:Vector2) -> void:
	linkedRoom = a_linkedRoom
	position = a_position

func hasBeenUsed() -> bool:
	if destinationPortal == null:
		return false
	return  true

func getMapPosition() -> Vector2:
	return position
	
func setDestinationPortal(a_linkedPortal):
	destinationPortal = a_linkedPortal

func getDestinationPortal():
	return destinationPortal
	
func getDestinationPortalRoomId():
	return destinationPortal.linkedRoom.roomId
