extends Node2D


var window_size
var grid_step
var map_offset
var map_size
var map_bounds
var rng
var map
var pathfinder
var los
var tile_size
var display_mode
var points


func _ready() -> void:
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	window_size = get_viewport().size
	map_offset = Vector2(window_size.x / 12, 0)
	map_size = Vector2(32, 17)
	grid_step = int((window_size.x - map_offset.x * 2) / map_size.x)
	map_bounds = Vector2(map_size.x * grid_step + map_offset.x, map_size.y * grid_step + map_offset.y)
	map = []
	tile_size = Vector2(grid_step, grid_step)
	
	display_mode = 0
	
	los = get_node("LoS")
	pathfinder = get_node("Pathfinder")
	
	generate_map()
	update()


func generate_map():
	map = []
	pathfinder.astar.clear()
	var tile_count = 0
	
	for x in range(map_size.x):
		map.append([])
		for y in range(map_size.y):
			if x < 5 and y < 5:
				map[x].append(2)
			elif x < map_size.x / 2:
				map[x].append(rng.randi_range(0, 10))
			else:
				map[x].append(map[map_size.x - x - 1][map_size.y - y - 1])
			
			if map[x][y] > 1:
				pathfinder.astar.add_point(tile_count, Vector2(x, y))
				if x > 0:
					if map[x - 1][y] > 1:
						pathfinder.astar.connect_points(tile_count, tile_count - map_size.y)
				if y > 0:
					if map[x][y - 1] > 1:
						pathfinder.astar.connect_points(tile_count, tile_count - 1)
			
			tile_count += 1


func draw_grid():
	for x in range(map_size.x + 1):
		draw_line(Vector2(x * grid_step + map_offset.x, map_offset.y), Vector2(x * grid_step + map_offset.x, map_bounds.y), Color(0, 0, 0))
		
	for y in range(map_size.y + 1):
		draw_line(Vector2(map_offset.x, y * grid_step + map_offset.y), Vector2(map_bounds.x, y * grid_step + map_offset.y), Color(0, 0, 0))


func draw_map():
	draw_rect(Rect2(Vector2(0, 0), window_size), Color(1, 1, 1), true)
	
	var color
	var start
	
	for x in range(map_size.x):
		for y in range(map_size.y):
			match map[x][y]:
				0:
					color = Color(0, 0, 0)
				1:
					color = Color(0.5, 0.5, 0.5)
				_:
					color = Color(1, 1, 1)
			
			start = Vector2(x * grid_step + map_offset.x, y * grid_step + map_offset.y)
			draw_rect(Rect2(start, tile_size), color)


func draw_path():
	var start
	var color = Color(0, 1, 0)
	
	for tile in pathfinder.path:
		start = Vector2(tile.x * grid_step + map_offset.x, tile.y * grid_step + map_offset.y)
		draw_rect(Rect2(start, tile_size), color)


func draw_all_movements():
	pass


func draw_los():
	pass


func _draw() -> void:
	draw_map()
	
	match display_mode:
		0:
			draw_path()
		1:
			draw_los()
		2:
			draw_all_movements()
		
	draw_grid()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	generate_map()
#	update()
	pass


func _input(event):
	if event is InputEventMouseButton:
		pathfinder.set_start(event.position)
		pathfinder.compute_path(event.position)
		update()
	
	if event is InputEventMouseMotion:
		pathfinder.compute_path(event.position)
		update()
		
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()
			
		if event.pressed and event.scancode == KEY_0:
			display_mode = 0
			print(display_mode)
		if event.pressed and event.scancode == KEY_1:
			display_mode = 1
			print(display_mode)
		if event.pressed and event.scancode == KEY_2:
			display_mode = 2
			print(display_mode)
