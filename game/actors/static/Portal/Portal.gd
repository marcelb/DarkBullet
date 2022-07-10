extends Area2D

var roomService # :RoomService
var linkedPortal:LinkedPortal

func setup(a_position: Vector2, a_linkedPortal:LinkedPortal, a_roomService):
	global_position = a_position
	linkedPortal = a_linkedPortal
	roomService = a_roomService

func _body_entered(body):
	if body.name == Player.typeName:
		roomService.portal_entered_by_player(self, body)



