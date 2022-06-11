extends Node2D

onready var player:KinematicBody2D = $Player
onready var camera:Camera2D = $Player/Camera2D

func _ready():
	VisualServer.set_default_clear_color(Color(0, 0, 0.2, 1) )
	CurrentWorld.generate()
	$ScrollingTileMap.setup(player, camera)
	$Player/ScrollingGround.setup(player)

#func _process(delta):
#	pass

func _on_HUDUpdateTimer_timeout():
	$CanvasLayer/FPS.text = str(Engine.get_frames_per_second())
	$CanvasLayer/WorldPosition.text = str(player.global_position)
