extends KinematicBody2D

const SPEED = 200

func _ready():
	pass

func _physics_process(delta):
	var velocity = Input.get_vector("player_left", "player_right", "player_up", "player_down") * SPEED
	# global_position = global_position + velocity * SPEED * delta
	move_and_slide(velocity)
