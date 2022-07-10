class_name Player extends KinematicBody2D

const typeName = "Player"
const SPEED = 200

func _ready():
	pass
	
func get_class(): return typeName

func _physics_process(delta):
	var velocity = Input.get_vector("player_left", "player_right", "player_up", "player_down") * SPEED
	move_and_slide(velocity)
