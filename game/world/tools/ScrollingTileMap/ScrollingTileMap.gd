extends TileMap

const REMOVE_INVISIBLE_TILES = false

const WORLD_WIDTH_OFFSET = CurrentWorld.WIDTH / 2
const WORLD_HEIGHT_OFFSET = CurrentWorld.HEIGHT / 2
const WORLD_OFFSET_VECTOR = Vector2(WORLD_WIDTH_OFFSET, WORLD_HEIGHT_OFFSET)

const VISIBLE_SIZE_VECTOR_TEST_OFFSET = 0

var visibleSizeVectorOffset = Vector2(10, 10)

var player:KinematicBody2D = null
var camera:Camera2D = null
var lastPlayerTilePos = null

func _ready():
	get_tree().get_root().connect("size_changed", self, "_onScreenResize")
	
func _onScreenResize():
	_recalculateAndDrawScreenBoundaries()

func _recalculateAndDrawScreenBoundaries():
	var viewportRect = camera.get_viewport_rect()
	visibleSizeVectorOffset = Vector2(ceil(viewportRect.size.x/cell_size.x/2)+1-VISIBLE_SIZE_VECTOR_TEST_OFFSET, ceil(viewportRect.size.y/cell_size.y/2)+1-VISIBLE_SIZE_VECTOR_TEST_OFFSET)
	var playerTilePosition = world_to_map(player.global_position)
	clear()
	_setRectangle(playerTilePosition)

func setup(myPlayer, myCamera):
	self.player = myPlayer
	self.camera = myCamera
	_recalculateAndDrawScreenBoundaries()
	var playerTilePosition = world_to_map(player.global_position)
	# print(playerTilePosition-visibleSizeVectorOffset, " to ", playerTilePosition+visibleSizeVectorOffset)
	_setRectangle(playerTilePosition)
	lastPlayerTilePos = playerTilePosition

func _isOnArrayMap(tilePos:Vector2):
	return tilePos.x in range(0, CurrentWorld.WIDTH-1) && tilePos.y in range(0, CurrentWorld.HEIGHT-1)

func _translateToArrayCoords(pos:Vector2):
	return Vector2(pos.x - WORLD_WIDTH_OFFSET, pos.y - WORLD_HEIGHT_OFFSET)

func _setCellFromArrayData(cell: Vector2):
	var arrayPos = cell + WORLD_OFFSET_VECTOR
	if _isOnArrayMap(arrayPos) && CurrentWorld.world[arrayPos.x][arrayPos.y] > -1:
		set_cellv(cell, CurrentWorld.world[arrayPos.x][arrayPos.y])
		
func _removeCell(cell: Vector2):
	if REMOVE_INVISIBLE_TILES:
		set_cellv(cell, -1)
	
func _setRectangle(playerPos: Vector2):
	for x in range(playerPos.x - visibleSizeVectorOffset.x, playerPos.x + visibleSizeVectorOffset.x):
		for y in range(playerPos.y - visibleSizeVectorOffset.y, playerPos.y + visibleSizeVectorOffset.y):
				_setCellFromArrayData(Vector2(x, y))
				
func _setColumn(pos: Vector2):
	for y in range(pos.y - visibleSizeVectorOffset.y, pos.y + visibleSizeVectorOffset.y):
			_setCellFromArrayData(Vector2(pos.x, y))

func _setRow(pos: Vector2):
	for x in range(pos.x - visibleSizeVectorOffset.x, pos.x + visibleSizeVectorOffset.x):
			_setCellFromArrayData(Vector2(x, pos.y))

func _removeColumn(pos: Vector2):
		for y in range(pos.y - visibleSizeVectorOffset.y, pos.y + visibleSizeVectorOffset.y):
				_removeCell(Vector2(pos.x, y))

func _removeRow(pos: Vector2):
		for x in range(pos.x - visibleSizeVectorOffset.x, pos.x + visibleSizeVectorOffset.x):
				_removeCell(Vector2(x, pos.y))

func _process(_delta):
	if player != null:
		var playerTilePosition = world_to_map(player.global_position)
		if playerTilePosition != lastPlayerTilePos:
			# print(playerTilePosition-VISIBLE_SIZE_VECTOR_OFFSET, " to ", playerTilePosition+VISIBLE_SIZE_VECTOR_OFFSET)
			# print(camera.get_camera_screen_center())
			
			if (playerTilePosition.x > lastPlayerTilePos.x):
				_setColumn(playerTilePosition+Vector2(visibleSizeVectorOffset.x-1, 0))
				_removeColumn(lastPlayerTilePos-Vector2(visibleSizeVectorOffset.x, 0))
			elif (playerTilePosition.x < lastPlayerTilePos.x):
				_setColumn(playerTilePosition-Vector2(visibleSizeVectorOffset.x, 0))
				_removeColumn(lastPlayerTilePos+Vector2(visibleSizeVectorOffset.x-1, 0))
				
			if (playerTilePosition.y > lastPlayerTilePos.y):
				_setRow(playerTilePosition+Vector2(0, visibleSizeVectorOffset.y-1))
				_removeRow(lastPlayerTilePos-Vector2(0, visibleSizeVectorOffset.y))
			elif (playerTilePosition.y < lastPlayerTilePos.y):
				_setRow(playerTilePosition-Vector2(0, visibleSizeVectorOffset.y))
				_removeRow(lastPlayerTilePos+Vector2(0, visibleSizeVectorOffset.y-1))
			
		lastPlayerTilePos = playerTilePosition
