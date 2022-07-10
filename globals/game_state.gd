extends Node
# class_name GameState 

var rootRoom: LinkedRoom
var currentRoom: LinkedRoom
var nextId = 0

func getNextId():
	var currentId = nextId
	nextId += 1
	return currentId	
