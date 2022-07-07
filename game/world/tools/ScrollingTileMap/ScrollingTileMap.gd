class_name ScrollingTileMap extends TileMap

const REMOVE_INVISIBLE_TILES = false
const VISIBLE_SIZE_VECTOR_TEST_OFFSET = 0

var linkedRoom: LinkedRoom
var worldWidthOffset: int
var worldHeightOffset: int
var worldOffsetVector: Vector2

var visibleSizeVectorOffset = Vector2(10, 10)

var player:KinematicBody2D = null
var camera:Camera2D = null
var lastPlayerTilePos = null

func _ready():
	get_tree().get_root().connect("size_changed", self, "_onScreenResize")

func _onScreenResize():
	_recalculateAndDrawScreenBoundaries(world_to_map(player.global_position))

func _recalculateAndDrawScreenBoundaries(playerTilePosition:Vector2):
	var viewportRect = camera.get_viewport_rect()
	visibleSizeVectorOffset = Vector2(ceil(viewportRect.size.x/cell_size.x/2)+1-VISIBLE_SIZE_VECTOR_TEST_OFFSET, ceil(viewportRect.size.y/cell_size.y/2)+1-VISIBLE_SIZE_VECTOR_TEST_OFFSET)
	clear()
	_setRectangle(playerTilePosition)

func setup(p_linkedRoom: LinkedRoom, p_player, p_camera):
	linkedRoom = p_linkedRoom
	worldWidthOffset = p_linkedRoom.width / 2
	worldHeightOffset = p_linkedRoom.height / 2
	worldOffsetVector = Vector2(worldWidthOffset, worldHeightOffset)
	player = p_player
	camera = p_camera
	var playerTilePosition = world_to_map(player.global_position)
	_recalculateAndDrawScreenBoundaries(playerTilePosition)
	lastPlayerTilePos = playerTilePosition

func translateMapToWorldWithOffset(mapCoord:Vector2) -> Vector2:
	return map_to_world(_translateToWorldTileCoords(mapCoord))
	
func translateWorldToMapWithOffset(worldCoord:Vector2) -> Vector2:
	return _translateToArrayCoords(world_to_map(worldCoord))

func _translateToWorldTileCoords(pos:Vector2):
	return pos - worldOffsetVector

func _translateToArrayCoords(pos:Vector2):
	return pos + worldOffsetVector

func _setCellFromArrayData(cell: Vector2):
	var arrayPos = _translateToArrayCoords(cell)
	var tileAtPos = linkedRoom.getTileAtPos(arrayPos)
	if tileAtPos > TileIds.NOTHING:
		set_cellv(cell, tileAtPos)
		
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
	if linkedRoom != null && player != null:
		var playerTilePosition = world_to_map(player.global_position)
		if playerTilePosition != lastPlayerTilePos:
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
