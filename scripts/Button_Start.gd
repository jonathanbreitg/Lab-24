extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var level = "level1"
var s
# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open("user://cur_level.dat", File.READ)
	var content = file.get_as_text()
	file.close()
	level = str(content)
	level = level.replace("\n","")
	print(level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _pressed():
	s = "res://levels/%s.tscn" % level
	print(level)
	print(s)
	get_tree().change_scene(s)
