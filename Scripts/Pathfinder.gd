extends Spatial


var astar
var start
var previous_path
var path
var tiles
var map_size
var all_possible_moves
var all_previous_possible_moves
var path_color


func _ready() -> void:
	astar = AStar2D.new()
	previous_path = []
	path = []
	all_possible_moves = []
	all_previous_possible_moves = []
	path_color = Color(0, 0.7, 0)


func reset_state():
	for pos in all_possible_moves:
		tiles[pos.x][pos.y].reset_color()
		
	for pos in path:
		tiles[pos.x][pos.y].reset_color()
	
	previous_path = []
	path = []
	all_possible_moves = []
	all_previous_possible_moves = []


func get_id_from_pos(pos: Vector2) -> int:
	var id
	if tiles:
		id = pos.x * map_size + pos.y
	return id


func set_start(tile):
	start = tile

func set_tiles(new_tiles):
	tiles = new_tiles
	map_size = len(tiles)


func display_all_path():
	for pos in all_previous_possible_moves:
		tiles[pos.x][pos.y].reset_color()
	
	for pos in all_possible_moves:
		tiles[pos.x][pos.y].change_color(path_color)


func display_path():
	for pos in previous_path:
		tiles[pos.x][pos.y].reset_color()

	for pos in path:
		tiles[pos.x][pos.y].change_color(path_color)


func get_all_path(max_move: int):
	var pos
	var id
	var temp_path
	
	all_previous_possible_moves = all_possible_moves
	all_possible_moves = []
	
	for x in range(-max_move, max_move + 1):
		for y in range(-max_move, max_move + 1):
			pos = Vector2(start.pos.x + x, start.pos.y + y)
			
			if pos.x >= 0 and pos.y >= 0 and pos.x < map_size and pos.y < map_size:
				if abs(x) + abs(y) <= max_move:
					id = get_id_from_pos(pos)
					if astar.has_point(id):
						temp_path = astar.get_point_path(start.id, id)
						
						if len(temp_path) <= max_move + 1:
							for point in temp_path:
								if not (point in all_possible_moves):
									all_possible_moves.append(point)


func compute_path(id: int):
	if start:
		previous_path = path
		path = astar.get_point_path(start.id, id)
