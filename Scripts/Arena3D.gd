extends Spatial


var rng
var tile
var obstacle
var pathfinder
var display_mode
var map
var tile_instances
var camera
var map_size
var target_tile


func _ready() -> void:
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	map_size = 35
	tile_instances = []
	
	tile = load("res://Scenes/Tile.tscn")
	obstacle = load("res://Scenes/Obstacle.tscn")
	
	pathfinder = get_node("Pathfinder")
	camera = get_node("Camera")

	generate_map()


func generate_map():
	for rows in tile_instances:
		for instance in rows:
			if instance:
				instance.queue_free()
	
	tile_instances = []
	map = []
	pathfinder.astar.clear()
	var id = 0
	
	for i in range(map_size):
		map.append([])
		tile_instances.append([])
		for k in range(map_size):
			if i < k + 15 and i > k - 15 and k + i < 55 and k + i > 15:
				var spawn
				
				if i < 6 or i > 29:
					spawn = tile.instance()
					spawn.id = id
					map[i].append(2)
				else:
					if i <= 17:
						var rand_num = rng.randi_range(0, 10)
						if rand_num < 9:
							spawn = tile.instance()
							spawn.id = id
							map[i].append(2)
						elif rand_num == 9:
							spawn = obstacle.instance()
							map[i].append(1)
						else:
							map[i].append(0)
					else:
						if map[36 - i - 1][36 - k - 1] == 2:
							spawn = tile.instance()
							spawn.id = id
							map[i].append(2)
						elif map[36 - i - 1][36 - k - 1] == 1:
							spawn = obstacle.instance()
							map[i].append(1)
						else:
							map[i].append(0)
				
				if spawn:
					spawn.transform.origin.x = k - 20
					spawn.transform.origin.z = i - 15
					spawn.pos = Vector2(i, k)
					
					tile_instances[i].append(spawn)
					
					add_child(spawn)
				else:
					tile_instances[i].append(null)
			else:
				map[i].append(0)
				tile_instances[i].append(null)
				
			if map[i][k] == 2:
				pathfinder.astar.add_point(id, Vector2(i, k))
				
				if i > 0:
					if map[i - 1][k] == 2:
						pathfinder.astar.connect_points(id, id - map_size)
				if k > 0:
					if map[i][k - 1] == 2:
						pathfinder.astar.connect_points(id, id - 1)
			
			id += 1
			
	for row in tile_instances:
		for instance in row:
			if instance:
				if instance.type == "Tile":
					instance.connect("tile_hovered", self, "mouse_in_tile")
					instance.connect("tile_left", self, "mouse_out_tile")
	
	pathfinder.set_tiles(tile_instances)


func mouse_in_tile(tile_instance):
	target_tile = tile_instance
	
func mouse_out_tile(tile_instance):
	target_tile = tile_instance


#func _process(_delta: float) -> void:
#	pass


func _input(event):
	if event is InputEventMouseButton:
		if target_tile:
			pathfinder.set_start(target_tile.id)
			pathfinder.compute_path(target_tile.id)
			pathfinder.display_path()
	
	if event is InputEventMouseMotion:
		if target_tile:
			pathfinder.compute_path(target_tile.id)
			pathfinder.display_path()
	
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
		if event.pressed and event.scancode == KEY_3:
			generate_map()
