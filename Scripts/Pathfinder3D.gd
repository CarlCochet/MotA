extends Spatial


var astar
var start_id
var previous_path
var path
var tiles


func _ready() -> void:
	astar = AStar2D.new()
	start_id = 50
	previous_path = []
	path = []


func reset_state():
	pass


func set_start(id: int):
	start_id = id

func set_tiles(new_tiles):
	tiles = new_tiles


func display_all_path():
	pass


func display_path():
	for pos in previous_path:
		tiles[pos.x][pos.y].change_color(Color(1, 1, 1))

	for pos in path:
		tiles[pos.x][pos.y].change_color(Color(0, 1, 0))


func get_all_path():
	pass


func compute_path(id: int):
	previous_path = path
	path = astar.get_point_path(start_id, id)



