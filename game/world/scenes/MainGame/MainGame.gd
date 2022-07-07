extends Node2D

onready var Player:KinematicBody2D = $Player
onready var Camera:Camera2D = $Player/Camera2D
onready var RoomService = $Scripts/RoomService
onready var ScrollingGround = $Player/ScrollingGround
onready var ScrollingTileMap = $ScrollingTileMap
onready var Portals = $Portals

func _ready():
	VisualServer.set_default_clear_color(Color(0, 0, 0.2, 1))
	ScrollingGround.setup(Player)
	RoomService.setup(self, Portals, ScrollingTileMap, Player, Camera)

func _on_HUDUpdateTimer_timeout():
	$CanvasLayer/FPS.text = str(Engine.get_frames_per_second())
	var playerPos = str(Player.global_position)
	var playerTile = str(ScrollingTileMap.translateWorldToMapWithOffset(Player.global_position))
	var amountOfPortals = str(CurrentWorld.currentRoom.amountOfPortals())
	var text = "Pos " + playerPos + "\nTile " + playerTile + "\nPortals " + amountOfPortals
	$CanvasLayer/WorldPosition.text = text
