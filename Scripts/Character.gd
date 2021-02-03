extends Spatial


var movement_points
var action_points
var range_bonus

var outfit

func _ready() -> void:
	movement_points = 2
	action_points = 4
	range_bonus = 0
	
	var body = load("res://Scenes/Models/Character.tscn").instance()
	add_child(body)
	
	outfit = get_node("Outfit")
	outfit.get_dressed("druid")
