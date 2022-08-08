extends Node
# class_name GlobalsMain

const PORTALS_MAX = 4

const ROOM_MIN_WIDTH = 20
const ROOM_MIN_HEIGHT = 20
const ROOM_MAX_WIDTH = 50
const ROOM_MAX_HEIGHT = 50

var rng:RandomNumberGenerator = RandomNumberGenerator.new()
var globalState = {}

func _ready():
	print("Initializing RNG...")
	rng.randomize()

# Helpers

func getRandomVector2(minX, maxX, minY, maxY):
	return Vector2(rng.randi_range(minX, maxX), rng.randi_range(minY,maxY))
	
func removeFromArray(arrayToChange:Array, valuesToRemove:Array):
	for it in valuesToRemove:
		while arrayToChange.has(it):
			arrayToChange.erase(it)
