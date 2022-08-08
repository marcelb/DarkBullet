class_name LinkedRoom extends Reference

const MINIMUM_PORTALS = 1
const MAX_PLACING_TRIES = 20

var roomId:int
var width:int = 0
var height:int = 0
var tiles:Array2D # 2D Array of ints
var portals:Array = [] # Array of LinkedPortals
var isInitialized : bool = false

func _init(a_width:int, a_height:int) -> void:
	roomId = GameState.getNextId()
	width = a_width
	height = a_height
	tiles = Array2D.new(width, height)
	portals = []
	isInitialized = false

func getPortals() -> Array:
	return portals

func amountOfPortals() -> int:
	return portals.size()
	
func hasPortals() -> bool:
	return amountOfPortals() > 0

func isPortal(pos_x, pos_y) -> bool:
	return isPortalv(Vector2(pos_x, pos_y))

func isPortalv(pos: Vector2) -> bool:
	for portal in portals:
		if (portal.getMapPosition() == pos):
			return true
	return false

func hasTileAtPos(pos: Vector2) -> bool:
	return tiles.has_cellv(pos)

func getTileAtPosv(pos: Vector2) -> int:
	return getTileAtPos(pos.x, pos.y)

func getTileAtPos(x:int, y:int) -> int:
	var cell = tiles.get_cell(x, y)
	return cell if cell != null else TileIds.NOTHING

func generate(entryPortal: LinkedPortal) -> void:
	if !isInitialized:
		var time_start = OS.get_ticks_msec()
		
		generateBorder()
		generateRoomInside()
		generatePortals(entryPortal)
		
		isInitialized = true
		print("Room generating time: ", OS.get_ticks_msec() - time_start)

func generateBorder():
	for x in width:
		tiles.set_cell(x, 0, TileIds.BLUE)
		tiles.set_cell(x, height-1, TileIds.BLUE)
	
	for y in height:
		tiles.set_cell(0, y, TileIds.BLUE)
		tiles.set_cell(width-1, y, TileIds.BLUE)
	
func generateRoomInside():
	for x in width-2:
		for y in height-2:
			tiles.set_cell(x+1, y+1, clamp(GlobalsMain.rng.randi_range(-160, 3), -1, 1)) 

enum PortalLocations {
	NORTH,
	EAST,
	SOUTH,
	WEST
}

func getDesiredPortalLocation(usedPortalLocations:Array):
	var remainingPortalLocations = PortalLocations.keys()
	GlobalsMain.removeFromArray(remainingPortalLocations, usedPortalLocations)
	
	if (remainingPortalLocations.size() > 0): # fill all sides
		var portalLocationKey = GlobalsMain.rng.randi_range(0, remainingPortalLocations.size() - 1)
		var chosenKey = remainingPortalLocations[portalLocationKey]
		return chosenKey
	else: # if all sides filled just add a new portal anywhere
		var portalLocationKey = GlobalsMain.rng.randi_range(0, PortalLocations.size() - 1)
		return PortalLocations.keys()[portalLocationKey]
		
func generatePortals(entryPortal: LinkedPortal):
	var usedPortalLocations: Array = [] # PortalLocations
	var amountOfPortals = 4 #GlobalsMain.rng.randi_range(0, GlobalsMain.PORTALS_MAX)
	
	if(amountOfPortals > 0):
		for n in amountOfPortals:
			var desiredPortalLocation = getDesiredPortalLocation(usedPortalLocations)
			usedPortalLocations.append(desiredPortalLocation)
			var newPortalLocation = getValidPortalPosition(PortalLocations[desiredPortalLocation])
			var newPortal = LinkedPortal.new(self, newPortalLocation)
			portals.append(newPortal)
		
		# connect portal to room tree
		if entryPortal != null:
			portals[0].setDestinationPortal(entryPortal)
			entryPortal.setDestinationPortal(portals[0])
			

func randomEdgePortalForDesiredLocation(desiredLocation):
	match desiredLocation:
		PortalLocations.NORTH:
			return GlobalsMain.getRandomVector2(1, width-2, 0, 0)
		PortalLocations.EAST:
			return GlobalsMain.getRandomVector2(width-1, width-1, 1, height-2)
		PortalLocations.SOUTH:
			return GlobalsMain.getRandomVector2(1, width-2, height-1, height-1)
		PortalLocations.WEST:
			return GlobalsMain.getRandomVector2(0, 0, 1, height-2)
		_:
			print("desiredLocation is not a valid PortalLocations key: " + desiredLocation)
			return GlobalsMain.getRandomVector2(2, width-2, 0, 0)

func getValidPortalPosition(desiredLocation) -> Vector2:
	var newPortalLocation = randomEdgePortalForDesiredLocation(desiredLocation)
	var tries = 1
	
	while(tries < MAX_PLACING_TRIES && isPortalv(newPortalLocation)):
		newPortalLocation = randomEdgePortalForDesiredLocation(desiredLocation)
		tries += 1
		if (tries >= MAX_PLACING_TRIES):	
			newPortalLocation = findFirstFreeSlot() # should never happen
		
	if (newPortalLocation != null):
		tiles.set_cellv(newPortalLocation, TileIds.NOTHING)
		return newPortalLocation
	else:
		ErrorHandler.criticalError("No Portal location feasable for map. Tries: " + str(tries) + " and emergency placing failed as well.")
		return Vector2(0,0)
		
func findFirstFreeSlot():
	for x in width-2:
		for y in height-2:
			var newPortalLocation = Vector2(x,y)
			if tiles.get_cellv(newPortalLocation) <= TileIds.NOTHING and !isPortalv(newPortalLocation):
				return newPortalLocation
	return null
	
func getRandomEmptyTileAroundCoords(coords: Vector2):
	var startX = coords.x - 1
	var startY = coords.y - 1
	var endX = coords.x + 1
	var endY = coords.y + 1
	
	var possibleTiles: Array = []
	for n in MAX_PLACING_TRIES:
		for x in range(startX, endX+1):
			for y in range(startY, endY+1):
				if getTileAtPos(x, y) <= TileIds.NOTHING && !isPortal(x, y):
					possibleTiles.append(Vector2(x, y))

		if possibleTiles.size() > 0:
			var lol = 1
			var randomIndex = GlobalsMain.rng.randi_range(0, possibleTiles.size() - 1)
			return possibleTiles[randomIndex]
		else:
			startX -= 1
			endX += 1
			startY -= 1
			endY += 1
	
	var freeSlot = findFirstFreeSlot()
		
	if (freeSlot != null):
		return freeSlot
	else:
		ErrorHandler.criticalError("No free spawn point feasable for map. Tries: " + str(MAX_PLACING_TRIES) + " and emergency placing failed as well.")
		return Vector2(0,0)
	
