extends Node

var rng:RandomNumberGenerator = RandomNumberGenerator.new()
var globalState = {}

func _ready():
	print("Initializing RNG...")
	rng.randomize()

func _process(delta):
	pass
