extends Spatial


var start
var tiles
var map_size
var pos_in_sight
var previous_pos_in_sight
var all_los
var previous_all_los


func _ready() -> void:
	start = Vector2(1, 15)
	tiles = []
	pos_in_sight = []
	previous_pos_in_sight = []
	all_los = []
	previous_all_los = []


func reset_state():
	for pos in all_los:
		tiles[pos.x][pos.y].change_color(Color(1, 1, 1))

	start = Vector2(1, 15)
	pos_in_sight = []
	previous_pos_in_sight = []
	all_los = []
	previous_all_los = []

func set_start(tile):
	start = tile.pos


func set_tiles(new_tiles):
	tiles = new_tiles
	map_size = len(tiles)
	print("Tiles format: [", len(tiles), ",", len(tiles[0]), "]")


func display_all_los():
	for pos in previous_all_los:
		tiles[pos.x][pos.y].change_color(Color(1, 1, 1))
	
	for pos in all_los:
		tiles[pos.x][pos.y].change_color(Color(0, 0, 1))


func display_los():
	for pos in previous_pos_in_sight:
		tiles[pos.x][pos.y].change_color(Color(1, 1, 1))
	
	for pos in pos_in_sight:
		tiles[pos.x][pos.y].change_color(Color(0, 0, 1))


func get_all_los(max_range: int):
	var pos
	previous_all_los = all_los
	all_los = []
	
	var start_time = OS.get_ticks_usec()
	
	for x in range(-max_range, max_range):
		for y in range(-max_range, max_range):
			pos = Vector2(start.x + x, start.y + y)
			
			if pos.x >= 0 and pos.y >= 0 and pos.x < map_size and pos.y < map_size:
				if abs(x) + abs(y) <= max_range:
					var valid = compute_los(pos)
					
					for point in pos_in_sight:
						if not (point in all_los):
							all_los.append(point)
	
	print(OS.get_ticks_usec() - start_time, "µs")


func compute_los(target: Vector2):
	pos_in_sight = []
	
	var d = Vector2(abs(start.x - target.x), abs(start.y - target.y))
	var pos = start
	var n = d.x + d.y
	var vector = Vector2(1 if target.x > start.x else -1, 1 if target.y > start.y else -1)
	var error = d.x - d.y
	d *= 2
	
	while n > 0:
		if error > 0:
			pos.x += vector.x
			error -= d.y
		elif error == 0:
			pos += vector
			n -= 1
			error += d.x - d.y
		else:
			pos.y += vector.y
			error += d.x
		
		if pos.x >= 0 and pos.x < map_size and pos.y >= 0 and pos.y < map_size:
			if tiles[pos.x][pos.y]:
				if tiles[pos.x][pos.y].type == "Obstacle":
					break
				elif tiles[pos.x][pos.y].type == "Tile":
					pos_in_sight.append(pos)
		n -= 1
	
#	print(pos_in_sight)
	return pos.x == target.x and pos.y == target.y
