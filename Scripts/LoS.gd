extends Node


var arena
var start
var tiles


func _ready() -> void:
	arena = get_parent()
	start = Vector2(0, 0)
	tiles = []


func get_all_los(los_range: int):
	for i in range(los_range):
		for k in range(los_range):
			var a = 1


func set_start(pos: Vector2):
	if arena.map_offset.x < pos.x and pos.x < arena.map_bounds.x and arena.map_offset.y < pos.y and pos.y < arena.map_bounds.y:
		start = Vector2(int((pos.x - arena.map_offset.x) / arena.grid_step), int((pos.y - arena.map_offset.y) / arena.grid_step))


func compute_los(target: Vector2) -> bool:
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
		
		if pos.x >= 0 and pos.x < arena.map_size.x and pos.y >= 0 and pos.y < arena.map_size.y:
			if arena.map[pos.x][pos.y] == 1:
				break
			elif arena.map[pos.x][pos.y] > 1:
				tiles.append(pos)
		n -= 1
	
	return pos.x == target.x and pos.y == target.y
