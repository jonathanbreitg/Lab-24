extends RichTextLabel
signal on_death
var deaths = 0
var txt
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Player_died():
	print(deaths)
	txt = "deaths: %d"
	print(txt % deaths)
	self.text = txt % deaths
	deaths += 1
