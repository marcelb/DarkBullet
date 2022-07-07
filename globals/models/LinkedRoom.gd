class_name LinkedRoom extends Reference

const MAX_PORTAL_PLACING_TRIES = 20

var width:int = 0
var height:int = 0
var tiles:Array2D # 2D Array of ints
var portals:Array = [] # Array of LinkedPortals
var isInitialized : bool = false

func _init(a_width:int, a_height:int) -> void:
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

func isPortal(pos: Vector2) -> bool:
	for portal in portals:
		if (portal.pos == pos):
			return true
	return false

func hasTileAtPos(pos: Vector2) -> bool:
	return tiles.has_cellv(pos)

func getTileAtPos(pos: Vector2) -> int:
	var cell = tiles.get_cellv(pos)
	return cell if cell != null else TileIds.NOTHING

func generate(minimumPortals:int = 0) -> void:
	var time_start = OS.get_ticks_msec()
	
	generateBorder()
	generateRoomInside()
	generatePortals(minimumPortals)

	
	isInitialized = true
	print("World generating time: ", OS.get_ticks_msec() - time_start)

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
			
func generatePortals(minimumPortals:int):
	# TODO possible bugs: Portal on Player Position
	var amountOfPortals = GlobalsMain.rng.randi_range(minimumPortals, clamp(minimumPortals+3, 0, GlobalsMain.PORTALS_MAX))
	
	for n in amountOfPortals:
		var newPortalLocation = GlobalsMain.getRandomVector2(1, width-2, 1, height-2)
		
		var tries = 1
		while(tries < MAX_PORTAL_PLACING_TRIES && (tiles.get_cellv(newPortalLocation) > TileIds.NOTHING or isPortal(newPortalLocation))):
			newPortalLocation = GlobalsMain.getRandomVector2(1, width-2, 1, height-2)
			tries += 1
		
		if (tries >= MAX_PORTAL_PLACING_TRIES):	
			newPortalLocation = findFirstFreeSlotForPortal()
		
		if (newPortalLocation != null):
			var newPortal = LinkedPortal.new(newPortalLocation)
			portals.append(newPortal)
		else:
			ErrorHandler.criticalError("No Portal location feasable for map. Tries: " + str(tries) + " and emergency placing failed as well.")
			
func findFirstFreeSlotForPortal():
	for x in width-2:
		for y in height-2:
			var newPortalLocation = Vector2(x,y)
			if tiles.get_cellv(newPortalLocation) <= TileIds.NOTHING and !isPortal(newPortalLocation):
				return newPortalLocation
	return null
	
