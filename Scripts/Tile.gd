extends Spatial


var pos
var id
var type
var color
var material
var collision_object
var collision_shape
var top

signal tile_hovered(tile)
signal tile_left(tile)

func _ready() -> void:
	type = "Tile"
	
	top = get_node("Top")
	
	material = top.get_material().duplicate()
	top.set_material(material)
	
	collision_object = StaticBody.new()
	collision_shape = CollisionShape.new()
	var shape = BoxShape.new()

	collision_shape.transform.origin.y = 0.25
	shape.set_extents(Vector3(0.5, 0.001, 0.5))
	collision_shape.set_shape(shape)
	
	collision_object.add_child(collision_shape)
	add_child(collision_object)
	
	collision_object.connect("mouse_entered", self, "_tile_hovered")
	collision_object.connect("mouse_exited", self, "_tile_left")


func change_color(new_color):
	material.albedo_color = new_color
	top.set_material(material)


func _tile_hovered():
	emit_signal("tile_hovered", self)

func _tile_left():
	emit_signal("tile_left", self)
