extends Spatial


var hat
var weapon
var clothes


func _ready() -> void:
	hat = null
	weapon = null
	clothes = null


func get_dressed(character_class):
	if character_class == "druid":
		hat = load("res://Scenes/Models/Druid_Hat.tscn").instance()
		add_child(hat)
