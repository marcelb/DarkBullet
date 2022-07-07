class_name RoomService extends Node

var Portal = preload("res://game/actors/static/Portal/Portal.tscn")

var scrollingTileMap: ScrollingTileMap
var player: KinematicBody2D
var camera: Camera2D
var world: Node2D
var portals: Node

func _ready():
	pass 
	
func setup(a_world: Node, a_portals: Node, a_scrollingTileMap: ScrollingTileMap, a_player:KinematicBody2D, a_camera: Camera2D):
	world = a_world
	portals = a_portals
	scrollingTileMap = a_scrollingTileMap
	player = a_player
	camera = a_camera
	CurrentWorld.generate()
	scrollingTileMap.setup(CurrentWorld.currentRoom, player, camera)
	
	for portal in CurrentWorld.currentRoom.getPortals():
		var portalWorldPosition = scrollingTileMap.translateMapToWorldWithOffset(portal.getTileMapPosition())
		portalWorldPosition += scrollingTileMap.cell_size / 2
		var newPortal = Portal.instance()
		newPortal.position = portalWorldPosition
		portals.add_child(newPortal)

#func _process(_delta):
#	pass
