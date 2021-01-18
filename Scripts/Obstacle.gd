extends Spatial


var pos
var id
var type
var color
var material


func _ready() -> void:
	material = get_node("Top").get_material()
	type = "Obstacle"


func change_color(new_color):
	material.albedo_color = new_color
	get_node("Top").set_material(material)
