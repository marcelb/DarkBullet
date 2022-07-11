class_name RoomService extends Node

var Portal = preload("res://game/actors/static/Portal/Portal.tscn")

var scrollingTileMap: ScrollingTileMap
var player: KinematicBody2D
var camera: Camera2D
var world: Node2D
var portalsNode: Node

func _generateNewRoom(comingFromPortal:LinkedPortal = null) -> LinkedRoom:
	var size:Vector2 = GlobalsMain.getRandomVector2(
		GlobalsMain.ROOM_MIN_WIDTH, 
		GlobalsMain.ROOM_MAX_WIDTH, 
		GlobalsMain.ROOM_MIN_HEIGHT, 
		GlobalsMain.ROOM_MAX_HEIGHT)
	var newRoom = LinkedRoom.new(size.x, size.y)
	newRoom.generate(comingFromPortal)
	return newRoom

func setup(a_world: Node, a_portalsNode: Node, a_scrollingTileMap: ScrollingTileMap, a_player:KinematicBody2D, a_camera: Camera2D):
	world = a_world
	portalsNode = a_portalsNode
	scrollingTileMap = a_scrollingTileMap
	player = a_player
	camera = a_camera
	GameState.rootRoom = _generateNewRoom()
	setupNewRoom(GameState.rootRoom)

func portal_entered_by_player(portal:Area2D, body:Node2D):
	if body.name == Player.typeName:
		changeRoomsThroughPortal(portal.linkedPortal)
		
func changeRoomsThroughPortal(linkedPortal:LinkedPortal):
	var newRoom
	var destinationPortal = linkedPortal.getDestinationPortal()
	if destinationPortal != null:
		newRoom = destinationPortal.linkedRoom
	else:
		newRoom = _generateNewRoom(linkedPortal)
		
	print("Traveling to new room with Id = " + str(newRoom.roomId))
	setupNewRoom(newRoom, linkedPortal.getDestinationPortal())

func setupNewRoom(newRoom:LinkedRoom, entryPortalInNewRoom: LinkedPortal = null):
	GameState.currentRoom = newRoom
	scrollingTileMap.setup(newRoom, player, camera)
	
	if entryPortalInNewRoom != null:
		var spawnTile = scrollingTileMap.translateFromArrayCoordsToTileMapCoords(entryPortalInNewRoom.getMapPosition())
		var spawnPosition = newRoom.getRandomEmptyTileAroundCoords(spawnTile)
		var playerAbsoluteSpawnPosition = scrollingTileMap.translateMapToWorld(spawnPosition)
		player.global_position = playerAbsoluteSpawnPosition
	else:
		player.global_position = Vector2(0,0)
	
	scrollingTileMap.forceDrawUpdate()
	
	removeAllPortals()
	addPortalsForRoom(newRoom)

func addPortalsForRoom(room: LinkedRoom):
	for portal in room.getPortals():
		var portalWorldPosition = scrollingTileMap.translateMapToWorldWithOffset(portal.getMapPosition())
		portalWorldPosition += scrollingTileMap.cell_size / 2
		var newPortal = Portal.instance()
		newPortal.setup(portalWorldPosition, portal, self)
		newPortal.connect("body_entered", newPortal, "_body_entered")
		portalsNode.add_child(newPortal)
		
func removeAllPortals():
	for portal in portalsNode.get_children():
		portal.queue_free()
	
