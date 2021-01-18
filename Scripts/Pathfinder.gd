extends Node2D


var arena
var astar
var start
var start_id
var path


func _ready() -> void:
	arena = get_parent()
	astar = AStar2D.new()
	start = Vector2(0, 0)
	start_id = 0
	path = []


func set_start(pos: Vector2):
	if arena.map_offset.x < pos.x and pos.x < arena.map_bounds.x and arena.map_offset.y < pos.y and pos.y < arena.map_bounds.y:
		start = Vector2(int((pos.x - arena.map_offset.x) / arena.grid_step), int((pos.y - arena.map_offset.y) / arena.grid_step))
		start_id = start.x * arena.map_size.y + start.y


func compute_path(target: Vector2):
	if arena.map_offset.x < target.x and target.x < arena.map_bounds.x and arena.map_offset.y < target.y and target.y < arena.map_bounds.y:
		var target_pos = Vector2(int((target.x - arena.map_offset.x) / arena.grid_step), int((target.y - arena.map_offset.y) / arena.grid_step))
		var target_id = target_pos.x * arena.map_size.y + target_pos.y
		
		if astar.has_point(target_id):
			path = astar.get_point_path(start_id, target_id)
