extends Control

const OPAQUE = Color(1,1,1,1)
const TRANSPARENT = Color(1,1,1,0)

onready var Label = $Center/Label

var state = {
	fadein = true
}

func _ready():
	if(state.fadein):
		Label.set_modulate(Color(1,1,1,0))

func _input(event):
	if (event is InputEventMouseButton or event is InputEventKey) and event.pressed:
		state.fadein = false
		$Timer.start()

func _process(delta):
	var fadeto = OPAQUE if state.fadein else TRANSPARENT
	Label.set_modulate(lerp(Label.get_modulate(), fadeto, 1*delta))
	pass


func _on_Timer_timeout():
	get_tree().change_scene("res://menus/MainMenu/MainMenu.tscn")
