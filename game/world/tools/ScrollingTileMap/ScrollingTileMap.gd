extends TileMap

const WORLD_WIDTH_OFFSET = CurrentWorld.WIDTH / 2
const WORLD_HEIGHT_OFFSET = CurrentWorld.HEIGHT / 2
const WORLD_OFFSET_VECTOR = Vector2(WORLD_WIDTH_OFFSET, WORLD_HEIGHT_OFFSET)

const VISIBLE_SIZE_WIDTH = 100
const VISIBLE_SIZE_HEIGHT = 50
const VISIBLE_SIZE_VECTOR_OFFSET = Vector2(VISIBLE_SIZE_WIDTH/2, VISIBLE_SIZE_HEIGHT/2)

var player = null
var lastPlayerTilePos = null

func _ready():
	pass

func setup(myPlayer):
	self.player = myPlayer
	var playerTilePosition = world_to_map(player.global_position)
	print(playerTilePosition-VISIBLE_SIZE_VECTOR_OFFSET, " to ", playerTilePosition+VISIBLE_SIZE_VECTOR_OFFSET)
	_setRectangle(playerTilePosition-VISIBLE_SIZE_VECTOR_OFFSET, playerTilePosition+VISIBLE_SIZE_VECTOR_OFFSET)
	lastPlayerTilePos = playerTilePosition

func _isOnArrayMap(tilePos:Vector2):
	return tilePos.x in range(0, CurrentWorld.WIDTH-1) && tilePos.y in range(0, CurrentWorld.HEIGHT-1)

func _translateToArrayCoords(pos:Vector2):
	return Vector2(pos.x - WORLD_WIDTH_OFFSET, pos.y - WORLD_HEIGHT_OFFSET)

func _setCellFromArrayData(cell: Vector2):
	var arrayPos = cell + WORLD_OFFSET_VECTOR
	if _isOnArrayMap(arrayPos):
		set_cellv(cell, CurrentWorld.world[arrayPos.x][arrayPos.y])
		
func _removeCell(cell: Vector2):
	set_cellv(cell, -1)
	
func _setRectangle(from: Vector2, to :Vector2):
	for x in range(from.x, to.x):
		for y in range(from.y, to.y):
				_setCellFromArrayData(Vector2(x, y))
				
				
func _setColumn(pos: Vector2):
		for y in range(pos.y - VISIBLE_SIZE_VECTOR_OFFSET.y, pos.y + VISIBLE_SIZE_VECTOR_OFFSET.y):
				_setCellFromArrayData(Vector2(pos.x, y))
				
func _setRow(pos: Vector2):
		for x in range(pos.x - VISIBLE_SIZE_VECTOR_OFFSET.x, pos.x + VISIBLE_SIZE_VECTOR_OFFSET.x):
				_setCellFromArrayData(Vector2(x, pos.y))
				
func _removeColumn(pos: Vector2):
		for y in range(pos.y - VISIBLE_SIZE_VECTOR_OFFSET.y, pos.y + VISIBLE_SIZE_VECTOR_OFFSET.y):
				_removeCell(Vector2(pos.x, y))
				
func _removeRow(pos: Vector2):
		for x in range(pos.x - VISIBLE_SIZE_VECTOR_OFFSET.x, pos.x + VISIBLE_SIZE_VECTOR_OFFSET.x):
				_removeCell(Vector2(x, pos.y))

func _process(_delta):
	if player != null:
		var playerTilePosition = world_to_map(player.global_position)
		if playerTilePosition != lastPlayerTilePos:
			# print(playerTilePosition-VISIBLE_SIZE_VECTOR_OFFSET, " to ", playerTilePosition+VISIBLE_SIZE_VECTOR_OFFSET)
			
			if (playerTilePosition.x > lastPlayerTilePos.x):
				_setColumn(playerTilePosition+Vector2(VISIBLE_SIZE_VECTOR_OFFSET.x-1, 0))
				_removeColumn(lastPlayerTilePos-Vector2(VISIBLE_SIZE_VECTOR_OFFSET.x, 0))
			elif (playerTilePosition.x < lastPlayerTilePos.x):
				_setColumn(playerTilePosition-Vector2(VISIBLE_SIZE_VECTOR_OFFSET.x, 0))
				_removeColumn(lastPlayerTilePos+Vector2(VISIBLE_SIZE_VECTOR_OFFSET.x-1, 0))
				
			if (playerTilePosition.y > lastPlayerTilePos.y):
				_setRow(playerTilePosition+Vector2(0, VISIBLE_SIZE_VECTOR_OFFSET.y-1))
				_removeRow(lastPlayerTilePos-Vector2(0, VISIBLE_SIZE_VECTOR_OFFSET.y))
			elif (playerTilePosition.y < lastPlayerTilePos.y):
				_setRow(playerTilePosition-Vector2(0, VISIBLE_SIZE_VECTOR_OFFSET.y))
				_removeRow(lastPlayerTilePos+Vector2(0, VISIBLE_SIZE_VECTOR_OFFSET.y-1))
			
		lastPlayerTilePos = playerTilePosition
