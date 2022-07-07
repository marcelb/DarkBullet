extends Sprite

# TODO change background size in response to window size changes

var player:KinematicBody2D = null
var lastPlayerPos:Vector2

func _ready():
	pass

func setup(myPlayer):
	self.player = myPlayer
	lastPlayerPos = player.global_position

func _process(_delta):
	if player != null && lastPlayerPos != null:
		var posDelta = player.global_position - lastPlayerPos
		if posDelta.length() > 0:
			region_rect.position += posDelta / transform.get_scale()
		lastPlayerPos = player.global_position
