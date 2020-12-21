extends Node2D


var window_size
var grid_step
var map_offset = Vector2(150, 0)
var map_size = Vector2(32, 17)
var rng = RandomNumberGenerator.new()
var map = []


func _ready() -> void:
	rng.randomize()
	
	window_size = get_viewport().size
	grid_step = int((window_size.x - map_offset.x * 2) / map_size.x)
	
	print(window_size, " | ", map_size, " | ", grid_step)
	
	generate_map()
	update()


func generate_map():
	map = []
	for x in range(map_size.x):
		map.append([])
		for y in range(map_size.y):
			if x < 5 and y < 5:
				map[x].append(2)
			elif x < map_size.x / 2:
				map[x].append(rng.randi_range(0, 10))
			else:
				map[x].append(map[map_size.x - x - 1][map_size.y - y - 1])
	

func draw_grid():
	for x in range(map_size.x + 1):
		draw_line(Vector2(x * grid_step + map_offset.x, map_offset.y), Vector2(x * grid_step + map_offset.x, map_size.y * grid_step + map_offset.y), Color(0, 0, 0))
		
	for y in range(map_size.y + 1):
		draw_line(Vector2(map_offset.x, y * grid_step + map_offset.y), Vector2(map_size.x * grid_step + map_offset.x, y * grid_step + map_offset.y), Color(0, 0, 0))


func draw_map():
	draw_rect(Rect2(Vector2(0, 0), window_size), Color(1, 1, 1), true)
	
	var color
	var start
	var tile_size = Vector2(grid_step, grid_step)
	
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
	pass


func draw_los():
	pass


func _draw() -> void:
	draw_map()
	draw_path()
	draw_los()
	draw_grid()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	generate_map()
	update()
