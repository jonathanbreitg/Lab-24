extends Control
var is_paused = false setget set_is_paused

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		self.is_paused = !is_paused


func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_quitBTN_pressed():
	print('unpaused')
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.visible = false
	self.is_paused = false
	
	
func _on_quitBTN2_pressed():
	print('unpaused2')
	get_tree().quit(0)
