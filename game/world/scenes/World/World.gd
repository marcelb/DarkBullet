extends Node2D

func _ready():
	VisualServer.set_default_clear_color(Color(0, 0, 0.2, 1) )
	CurrentWorld.generate()
	$ScrollingTileMap.setup($Player)

#func _process(delta):
#	pass

func _on_FPSUpdateTimer_timeout():
	$CanvasLayer/FPS.text = str(Engine.get_frames_per_second())
