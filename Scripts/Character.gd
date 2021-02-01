extends Spatial


var movement_points
var action_points
var range_bonus

var assets

func _ready() -> void:
	movement_points = 2
	action_points = 4
	range_bonus = 0
	
	assets = []
	var body = load("res://Scenes/Models/Character.tscn").instance()
	
	assets.append(body)
	add_child(body)
