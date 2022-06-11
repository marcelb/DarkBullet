extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player:KinematicBody2D = null
var lastPlayerPos:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(myPlayer):
	self.player = myPlayer
	lastPlayerPos = player.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player != null && lastPlayerPos != null:
		var posDelta = player.global_position - lastPlayerPos
		if posDelta.length() > 0:
			region_rect.position += posDelta / transform.get_scale()
		lastPlayerPos = player.global_position
